class CreateRegistrationPolicies < ActiveRecord::Migration
  def self.up
    create_table :registration_policies do |t|
      t.column :name, :string
      t.column :created_at, :date, :null => false
      t.column :updated_at, :date, :null => false
    end
  end

  def self.down
    drop_table :registration_policies
  end
end
