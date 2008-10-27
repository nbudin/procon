class ClosedEventRule < RegistrationRule
  # this event is closed; no registrations allowed
  
  def attendance_valid?(attendance)
    if attendance.is_staff
      return true
    else
      return false
    end
  end
  
  def error_message(attendance)
    return "Registration is closed for this event."
  end
end