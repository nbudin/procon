class Event < ActiveRecord::Base
  has_many :attendances, :order => "created_at", :dependent => :destroy
  has_many :attendee_slots, :foreign_key => "event_id"
  has_many :registration_buckets, :foreign_key => "event_id"  
  has_many :public_info_fields, :dependent => :destroy
  has_many :public_info_values, :through => :public_info_fields, :dependent => :destroy
  has_many :virtual_sites
  has_and_belongs_to_many :tracks
  belongs_to :registration_policy
  has_many :schedules
  has_many :event_locations, :dependent => :destroy
  has_many :locations, :through => :event_locations, :dependent => :destroy
  has_many :staffers, :dependent => :destroy, :order => "position"
  
  accepts_nested_attributes_for :attendances, :allow_destroy => true
  accepts_nested_attributes_for :attendee_slots, :allow_destroy => true
  accepts_nested_attributes_for :public_info_fields, :allow_destroy => true
  accepts_nested_attributes_for :virtual_sites, :allow_destroy => true
    
  scope :time_ordered, order("start, end")
  scope :in_schedule, lambda { |schedule|
    joins(:tracks).where(:tracks => { :id => schedule.track_ids }).select("DISTINCT `events`.*").includes(:tracks)
  }
  scope :for_registration, includes(:attendances => :person, 
    :registration_policy => :rules, 
    :attendee_slots => nil, 
    :locations => nil)    
  
  
  # possibly replace this with a confirmation check later
  validate do |e|
    if e.length and e.length > 2.weeks
      e.errors.add_to_base "Events cannot be longer than 2 weeks"
    end
  end
    
  has_ancestry
  
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
    if not sn.blank?
      return sn
    else
      return fullname
    end
  end
  
  def fullname
    fn = read_attribute(:fullname)
    if fn.blank?
      return "Untitled Event"
    else
      return fn
    end
  end
      
  
  def globally_visible?
    return parent.nil?
  end
  
  def simultaneous_events
    return [] unless self.start and self.end
    
    searchpool = if parent.nil?
      Event.find_all_by_parent_id nil
    else
      parent.children
    end.reject { |e| e == self or e.start.nil? or e.end.nil? }
    
    searchpool.select do |e|
      (e.end > self.start and e.start < self.end) 
    end
  end
  
  def shared_locations
    simevents = simultaneous_events
    event_locations.shareable.collect {|el| el.location}.select do |loc|
      simevents.collect do |e|
        e.locations.include? loc
      end.include? true
    end
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
    if not attendance.event.registration_policy.nil?
      if not attendance.event.registration_policy.attendance_valid?(attendance)
        return "The event's registration policy does not allow you to sign up."
      end
    end
  end
  
  def attendee_count(gender=nil)
    if gender.nil?
      attendances.select { |att| att.counts }.size
    else
      attendances.select { |att| att.counts and att.gender == gender }.size
    end
  end
  
  def waitlist_count(gender=nil)
    if gender.nil?
      attendances.select { |att| att.is_waitlist }.size
    else
      attendances.select { |att| att.is_waitlist and att.gender == gender }.size
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
    if self.end and self.start
      self.end - self.start
    end
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
  
  def registration_open
    not obtain_registration_policy.contains_rule_type? ClosedEventRule
  end

  def registration_open=(reg_open)
    policy = obtain_registration_policy

    if param_to_bool(reg_open)
      policy.each_rule_of_type ClosedEventRule do |rule|
        rule.destroy
      end
    else
      if not policy.contains_rule_type? ClosedEventRule
        ClosedEventRule.create :policy => policy
      end
    end
  end
  
  def non_exclusive
    not obtain_registration_policy.contains_rule_type? ExclusiveEventRule
  end

  def non_exclusive=(non_exc)
    policy = obtain_registration_policy

    if param_to_bool(non_exc)
      policy.each_rule_of_type ExclusiveEventRule do |rule|
        rule.destroy
      end
    else
      if not policy.contains_rule_type? ExclusiveEventRule
        ExclusiveEventRule.create :policy => policy
      end
    end
  end
  
  def age_restricted
    obtain_registration_policy.contains_rule_type? AgeRestrictionRule
  end

  def min_age
    policy = obtain_registration_policy

    if policy.contains_rule_type? AgeRestrictionRule
      return policy.rules.find_all_by_type('AgeRestrictionRule').collect { |r| r.min_age }.max
    else
      return nil
    end
  end

  def min_age=(ma)
    policy = obtain_registration_policy

    if ma.to_i > 0
      if not policy.contains_rule_type? AgeRestrictionRule
        AgeRestrictionRule.create :policy => policy
      end
      policy.reload
      policy.each_rule_of_type AgeRestrictionRule do |rule|
        rule.min_age = ma
        rule.save
      end
    else
      policy.each_rule_of_type AgeRestrictionRule do |rule|
        rule.destroy
      end
    end
  end
        
  def to_xml
    super(:methods => [:min_age, :age_restricted, :registration_open, :non_exclusive])
  end
  
  def capacity_limit(threshold, opts={})
    0
  end
  
  def capacity_limits()
    {}
  end
  
  def exclusive_location_ids
    locations.exclusive.collect { |loc| loc.id }
  end
  
  def shareable_location_ids
    locations.shareable.collect { |loc| loc.id }
  end
  
  def exclusive_location_ids=(loc_ids)
    set_location_ids(true, loc_ids)
  end
  
  def shareable_location_ids=(loc_ids)
    set_location_ids(false, loc_ids)
  end

  def attendees_with_blank_agenda
    attendances.confirmed.not_in_any_descendant(self).group(:person_id).includes(:person).map(&:person)
  end

  private
  def param_to_bool(param)
    if param.blank?
      return false
    else
      return param.to_s.downcase == "true"
    end
  end
  
  def set_location_ids(exclusive, loc_ids)
    locs = Location.find_all_by_id(loc_ids)
    keep_els = event_locations.select { |el| el.exclusive ^ exclusive }
    locs.each do |loc|
      keep_el = event_locations.select { |el| el.location == loc }.first
      keep_el ||= EventLocation.new :location => loc, :exclusive => exclusive
      keep_els << keep_el
    end
    self.event_locations = keep_els
  end
end
