class ExclusiveEventRule < RegistrationRule
  # you can only be signed up to one event that has this rule at a time
  
  def attendance_valid?(attendance)
    if attendance.is_staff
      return true
    end
    
    sametime = attendance.event.simultaneous_events
    
    Attendance.find_all_by_person_id(attendance.person.id).each do |a|
      if a.is_staff
        next
      end
      
      e = a.event
      if !sametime.include?(e)
        next
      end
      
      e.registration_policy.rules.each do |r|
        if r.kind_of? ExclusiveEventRule
          return false
        end
      end
    end
    
    return true
  end
  
  def error_message(attendance)
    return "That person is already registered for another event at that time."
  end
end
