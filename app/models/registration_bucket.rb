class RegistrationBucket < ActiveRecord::Base
  belongs_to :event
  has_one :rule, :class_name => "RegistrationRule", :foreign_key => "bucket_id", :dependent => :destroy
  acts_as_list :scope => :event
end
