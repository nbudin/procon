class RegistrationPolicy < ActiveRecord::Base
  has_many :rules, :class_name => "RegistrationRule", :foreign_key => "policy_id", :order => "position"
  has_many :events
  
  def attendance_valid?(attendance)
    rules.each do |r|
      if not r.attendance_valid?(attendance)
        return false
      end
    end
    return true
  end
  
  def contains_rule_type?(klass)
    rules.each do |rule|
      if rule.kind_of? klass
        return true
      end
    end
    return false
  end
  
  def each_rule_of_type(klass)
    rules.each do |rule|
      if rule.kind_of? klass
        yield rule
      end
    end
  end
end
