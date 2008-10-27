class CreateRegistrationBuckets < ActiveRecord::Migration
  def self.up
    create_table :registration_buckets do |t|
      t.column :event_id, :integer, :null => false
      t.column :position, :integer, :null => false
      
      t.column :max, :integer
      t.column :min, :integer
      t.column :preferred, :integer
    end
  end

  def self.down
    drop_table :registration_buckets
  end
end
