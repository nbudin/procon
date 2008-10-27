class ProconProfile < ActiveRecord::Base
  belongs_to :person
  
  def attendances
    Attendance.find_all_by_person_id(person.id)
  end
  
  def attendance_for_event(event_id)
    Attendance.find_by_person_id_and_event_id(person.id, event_id)
  end
  
  def attending?(event)
    attendance_for_event(event.id)
  end
  
  def events
    attendances.collect { |a| a.event }
  end
  
  def ignore_events_cond(ignore_events)
    if ignore_events.length > 0
      return "AND events.id NOT IN ("+ignore_events.collect { |e| e.id }.join(',') + ")"
    else
      return ""
    end
  end
  
  def busy_at?(time, ignore_events=[])
    return events.count(:all, 
      :conditions => ["start <= ? AND end > ? #{ignore_events_cond ignore_events}", time, time]) > 0
  end
  
  def busy_between?(start_time, end_time, ignore_events=[])
    return (busy_at?(start_time, ignore_events) or 
      events.count(:all, :conditions => ["(end > ? AND start <= ?) #{ignore_events_cond ignore_events}", 
        start_time, end_time]) > 0)
  end
  
  def has_edit_permissions?(event=nil)
    if event
      return event.has_edit_permissions?(person)
    else
      return person.permitted?(nil, "edit_events")
    end
  end
end