class ClosedEventRule < RegistrationRule
  # this event is closed; no new registrations allowed
  
  def attendance_valid?(attendance)
    if attendance.new_record? or attendance.changed?
      return false
    else
      return true
    end
  end
  
  def error_message(attendance)
    return "Registration is closed for this event."
  end
end