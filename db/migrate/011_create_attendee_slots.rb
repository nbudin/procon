class CreateAttendeeSlots < ActiveRecord::Migration
  def self.up
    create_table :attendee_slots do |t|
      t.column :event_id, :integer, :null => false
      t.column :max, :integer
      t.column :min, :integer
      t.column :preferred, :integer
      t.column :gender, :string
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :attendee_slots
  end
end
