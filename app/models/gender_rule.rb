class GenderRule < RegistrationRule
  def attendance_valid?(attendance)
    return attendance.gender == self.gender
  end
  
  def error_message(attendance)
    return "That person has the wrong gender to sign up for this event."
  end
end
