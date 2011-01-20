class ProconProfile < ActiveRecord::Base
  belongs_to :person
  
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
  
  def attendance_for_event(event)
    event.attendances.select { |att| att.person_id == person.id }.first
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
  
  def has_edit_permissions?(event=nil)
    if event
      return event.has_edit_permissions?(person)
    else
      return person.permitted?(nil, "edit_events")
    end
  end
end
