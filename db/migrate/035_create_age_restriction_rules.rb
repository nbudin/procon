class CreateAgeRestrictionRules < ActiveRecord::Migration
  def self.up
    add_column "registration_rules", "min_age", :integer
  end

  def self.down
    remove_column "registration_rules", "min_age"
  end
end
