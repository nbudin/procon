class ProposedEvent < ActiveRecord::Base
  belongs_to :proposer, :class_name => "Person"
  belongs_to :parent, :class_name => "Event"
  belongs_to :registration_policy
end
