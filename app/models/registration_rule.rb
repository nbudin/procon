class RegistrationRule < ActiveRecord::Base
  belongs_to :policy, :class_name => "RegistrationPolicy", :foreign_key => "policy_id"
  belongs_to :bucket, :class_name => "RegistrationBucket", :foreign_key => "bucket_id"
  acts_as_list :scope => :policy
  
  def self.rule_types
    %w( ClosedEventRule ExclusiveEventRule GenderRule ).sort
  end
  
  validate do |rule|
    if rule.bucket.nil? and rule.policy.nil?
      rule.errors.add_to_base "This registration rule doesn't belong to a bucket or a policy."
    elsif !rule.bucket.nil? and !rule.policy.nil?
      rule.errors.add_to_base "A registration rule can't belong to both a bucket and a policy."
    end
  end
  
  def attendance_valid?(attendance)
    return true
  end
  
  def error_message(attendance)
    return "That signup is disallowed by the event's registration policy."
  end
end