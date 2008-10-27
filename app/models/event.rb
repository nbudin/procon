class Event < ActiveRecord::Base
  acts_as_permissioned
  
  has_many :attendances, :order => "created_at", :dependent => :destroy
  
  private
  # convenience method for getting the actual people associated with a group
  # of attendances
  #
  # has_many :through won't do it because they're in different databases
  def self.get_people_method(method_name, conditions=nil, with_deleted=false)
    finder_method = with_deleted ? "find_with_deleted" : "find"
    args = ":all"
    if conditions
      args += ", :conditions => #{conditions.to_json}, :select => 'person_id'"
    end
    class_eval <<-ENDMETHOD
      def #{method_name}
        ids = attendances.#{finder_method}(#{args}).map(&:person_id)
        Person.find(:all, :conditions => ["id in (?)", ids])
      end
    ENDMETHOD
  end
  
  public
  
  get_people_method "all_attendees"
  get_people_method "confirmed_attendees", ["is_waitlist = ?", false]
  has_many :confirmed_attendances, :class_name => "Attendance", :order => "created_at", 
    :conditions => ["is_waitlist = ?", false], :dependent => :destroy
  get_people_method "staff", [ "is_staff = ?", true ]
  get_people_method "waitlist_attendees", ["is_waitlist = ?", true]
  has_many :waitlist_attendances, :class_name => "Attendance", :order => "created_at", 
    :conditions => ["is_waitlist = ?", true], :dependent => :destroy
  get_people_method "counted_attendees", ["counts = ?", true]
    
  has_many :event_locations, :dependent => :destroy
  has_many :locations, :through => :event_locations, :dependent => :destroy
  has_many :exclusive_locations, :through => :event_locations, :dependent => :destroy,
    :source => :location, :conditions => ["exclusive = ?", true]
  has_many :shareable_locations, :through => :event_locations, :dependent => :destroy,
    :source => :location, :conditions => ["exclusive = ?", false]
    
  belongs_to :registration_policy
  has_many :virtual_sites
    
  has_many :schedules
  has_and_belongs_to_many :tracks
  has_and_belongs_to_many :schedule_blocks
  has_many :scheduled_event_positions
  after_save :invalidate_blocks
    
  acts_as_tree :order => "start"
  
  def invalidate_blocks
    schedules.each do |schedule|
      schedule.schedule_blocks.destroy_all
    end
  end
  
  def set_default_registration_policy
    if registration_policy.nil?
      create_registration_policy
      save
    end
    
    is_closed = false
    is_exclusive = false
    registration_policy.rules.each do |rule|
      if rule.kind_of? ClosedEventRule
        is_closed = true
      end
      if rule.kind_of? ExclusiveEventRule
        is_exclusive = true
      end
    end
    
    if not is_closed
      ClosedEventRule.create :policy => registration_policy
    end
    
    if not is_exclusive
      ExclusiveEventRule.create :policy => registration_policy
    end
  end
  
  def shortname
    sn = read_attribute(:shortname)
    if sn and sn != ''
      return sn
    else
      return fullname
    end
  end
  
  def globally_visible?
    return parent.nil?
  end
  
  def simultaneous_events
    searchpool = if parent.nil?
      Event.find_all_by_parent_id nil
    else
      parent.children
    end.reject { |e| e == self }
    
    searchpool.select do |e|
      (e.end > self.start and e.start < self.end) 
    end
  end
  
  def shared_locations
    simevents = simultaneous_events
    shareable_locations.select do |loc|
      simevents.collect do |e|
        e.locations.include? loc
      end.include? true
    end
  end
  
  def visible_to?(person)
    if globally_visible?
      return true
    end
    if not person.nil? and parent.attendances.count(:conditions => ["person_id = ?", person.id]) > 0
      return true
    end
    return false
  end
   
  def attendees_visible_to?(person)
    if has_edit_permissions?(person)
      return true
    else
      if attendees_visible and all_attendees.include?(person)
        return true
      end
    end
    return false
  end
  
  def attendance_errors(attendance)
    errs = []
    if not registration_policy.nil?
      registration_policy.rules.each do |rule|
        if not rule.attendance_valid?(attendance)
          errs << rule.error_message(attendance)
        end
      end
    end
    return errs
  end
  
  def attendance_invalid?(attendance)
    if not visible_to? attendance.person
      return "That event is not visible to you.  To make it visible, sign up for its parent event: #{parent.fullname}"
    end
    
    if not attendance.event.registration_policy.nil?
      if not attendance.event.registration_policy.attendance_valid?(attendance)
        return "The event's registration policy does not allow you to sign up."
      end
    end
  end
  
  def attendee_count(gender=nil)
    if gender.nil?
      attendances.count :all, :conditions => ["counts = ?", true]
    else
      person_ids = attendances.find_all_by_counts(true, :select => "person_id").map(&:person_id)
      Person.count(:all, :conditions => ["gender = ? and id in (?)", gender, person_ids])
    end
  end
  
  def waitlist_count(gender=nil)
    if gender.nil?
      attendances.count :all, :conditions => ["is_waitlist = ?", true]
    else
      person_ids = attendances.find_all_by_is_waitlist(true, :select => "person_id").map(&:person_id)
      Person.count(:all, :conditions => ["gender = ? and id in (?)", gender, person_ids])
    end
  end
  
  def has_edit_permissions?(person)
    if person.nil?
      return false
    end
    if person.permitted?(self, "edit_events")
      return true
    elsif staff.include? person
      return true
    elsif parent
      return parent.has_edit_permissions?(person)
    end
  end
  
  def avg_age
    count = 0
    total = 0
    attendances.find_all_by_counts(true).each do |a|
      age = a.age
      if not age.nil?
        count += 1
        total += age
      end
    end
    return total.to_f / count
  end
  
  def length
    self.end - self.start
  end
  
  def obtain_registration_policy
    if registration_policy.nil?
      return create_registration_policy
    else
      return registration_policy
    end
  end
  
  def pull_from_children
    children_attendees = children.collect { |c| c.all_attendees }.flatten.uniq
    my_attendees = self.all_attendees
    children_attendees.each do |person|
      if not my_attendees.include? person
        Attendance.create :person => person, :event => self
      end
    end
  end
end