class Person < ActiveRecord::Base
  devise :cas_authenticatable, :trackable
  
  has_many :attendances
  has_many :events, :through => :attendances
  
  def name
    unless nickname.blank?
      "#{firstname} \"#{nickname}\" #{lastname}"
    else
      "#{firstname} #{lastname}"
    end
  end
  
  def current_age
    age_as_of Date.today
  end
  
  def age_as_of(base = Date.today)
    if not birthdate.nil?
      base.year - birthdate.year - ((base.month * 100 + base.day >= birthdate.month * 100 + birthdate.day) ? 0 : 1)
    end
  end
  
  def merge_person_id!(merge_id)
    count = 0
    
    transaction do
      Attendance.all(:conditions => {:person_id => merge_id}).each do |att|
        att.person = self
        att.save(false)
        count += 1
      end
    
      Event.all(:conditions => {:proposer_id => merge_id}).each do |event|
        event.proposer = self
        event.save(false)
        count += 1
      end
    end
    
    return count
  end
  
  def attendances
    if @attendances.nil?
      reload_attendances
    end
    @attendances.values
  end

  def reload_attendances
    @attendances = {}
    Attendance.find_all_by_person_id(id, :include => [:event]).each do |att|
      @attendances[att.event.id] = att
    end
  end
  
  def attendance_for_event(event)
    event.attendances.select { |att| att.person_id == id }.first
  end
  
  def attending?(event)
    attendance_for_event(event)
  end
  
  def events
    attendances.collect { |a| a.event }
  end
  
  def events_cond(events)
    if events.length > 0
      return "AND events.id IN ("+events.collect { |e| e.id }.join(',') + ")"
    else
      return ""
    end
  end

  def busy_at?(time, events=[])
    return Attendance.count(:conditions => ["start <= ? AND end > ? and person_id = ? #{events_cond events}", 
                                            time, time, person.id],
                            :joins => :event) > 0
  end
  
  def busy_between?(start_time, end_time, events=[])
    return (busy_at?(start_time, events) or 
            Attendance.count(:conditions => ["(end > ? AND start <= ?) and person_id = ? #{events_cond events}", 
                                             start_time, end_time, person.id],
                             :joins => :event) > 0)
  end
  
  def cas_extra_attributes=(extra_attributes)
    extra_attributes.each do |name, value|
      case name.to_sym
      when :firstname
        self.firstname = value
      when :lastname
        self.lastname = value
      when :birthdate
        self.birthdate = value
      when :gender
        self.gender = value
      when :email
        self.email = value
      end
    end
  end
end
