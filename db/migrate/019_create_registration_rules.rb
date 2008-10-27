class CreateRegistrationRules < ActiveRecord::Migration
  def self.up
    create_table :registration_rules do |t|
      t.column :type, :string, :null => false
      t.column :created_at, :date, :null => false
      t.column :updated_at, :date, :null => false
      t.column :policy_id, :integer
      t.column :bucket_id, :integer
      t.column :position, :integer, :null => false
      
      t.column :gender, :string
      t.column :age_min, :integer
      t.column :age_max, :integer
    end
  end

  def self.down
    drop_table :registration_rules
  end
end
