class ProconProfile < ActiveRecord::Base
  belongs_to :person
  
  def has_role?(role_name, obj=nil)
    case role_name.to_sym
    when :staff
      if obj.kind_of? Event
        obj.staff.include?(person) or (obj.parent && self.has_role?(:staff, obj.parent))
      end
    when :proposer
      if obj.kind_of? ProposedEvent
        person == obj.proposer
      end
    when :attendee
      if obj.kind_of? Event
        attending?(obj)
      end
    else
      person.has_role?(role_name, obj)
    end
  end
  
  def has_role!(role_name, obj=nil)
    case role_name.to_sym
    when :staff, :proposer, :attendee
      raise "Virtual roles can't be assigned using ProconProfile#has_role!"
    else
      person.has_role!(role_name, obj)
    end
  end
  
  def attendances
    if @attendances.nil?
      reload_attendances
    end
    @attendances.values
  end

  def reload_attendances
    @attendances = {}
    Attendance.find_all_by_person_id(person.id, :include => [:event]).each do |att|
      @attendances[att.event.id] = att
    end
  end
  
  def proposals
    @proposals ||= ProposedEvent.find_all_by_proposer_id(person.id)
  end
  
  def attendance_for_event(event_id)
    if @attendances.nil?
      reload_attendances
    end
    @attendances[event_id] || @attendances[event_id.id]
  end
  
  def attending?(event)
    attendance_for_event(event.id)
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
end
