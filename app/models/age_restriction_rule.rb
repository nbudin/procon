class AgeRestrictionRule < RegistrationRule
  def attendance_valid?(attendance, other_atts=nil)
    if attendance.is_staff
      return true
    end
    age = attendance.age
    if age.nil?
      return false
    end
    if self.min_age
      if age < self.min_age
        return false
      end
    end
    return true
  end
  
  def error_message(attendance)
    return "That person is too young to sign up for this event.  Minimum age is #{self.min_age}.  (Did you enter a birth date?  If not, hit 'Edit Profile' in the login box.)"
  end
end
