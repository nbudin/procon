class AssociateRegistrationPoliciesWithEvents < ActiveRecord::Migration
  def self.up
    add_column "events", "registration_policy_id", :integer
  end

  def self.down
    remove_column "events", "registration_policy_id"
  end
end
