class AgeRestrictionRule < RegistrationRule
  def attendance_valid?(attendance)
    age = attendance.age
    if self.min_age
      if age < self.min_age
        return false
      end
    end
    return true
  end
  
  def error_message(attendance)
    return "That person is too young to sign up for this event.  Minimum age is #{self.min_age}."
  end
end
