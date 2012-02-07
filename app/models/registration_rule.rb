class RegistrationRule < ActiveRecord::Base
  belongs_to :policy, :class_name => "RegistrationPolicy", :foreign_key => "policy_id"
  belongs_to :bucket, :class_name => "RegistrationBucket", :foreign_key => "bucket_id"
  acts_as_list :scope => :policy
  validate :must_be_in_bucket_xor_policy
  
  def self.rule_types
    %w( ClosedEventRule ExclusiveEventRule GenderRule ).sort
  end
    
  def attendance_valid?(attendance, other_atts=nil)
    return true
  end
  
  def error_message(attendance)
    return "That signup is disallowed by the event's registration policy."
  end
  
  private
  def must_be_in_bucket_xor_policy
    if bucket.nil? and policy.nil?
      errors.add_to_base "This registration rule doesn't belong to a bucket or a policy."
    elsif !bucket.nil? and !policy.nil?
      errors.add_to_base "A registration rule can't belong to both a bucket and a policy."
    end
  end
end