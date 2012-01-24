class ExclusiveEventRule < RegistrationRule
  # you can only be signed up to one event that has this rule at a time
  
  def attendance_valid?(attendance, other_atts=nil)
    if attendance.is_staff
      return true
    end
    
    if other_atts
      return other_atts.none? do |other_att| 
        (!other_att.is_staff &&
        other_att.event.simultaneous_with?(attendance.event) &&
        other_att.event.registration_policy.rules.any? { |r| r.kind_of? ExclusiveEventRule })
      end
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
