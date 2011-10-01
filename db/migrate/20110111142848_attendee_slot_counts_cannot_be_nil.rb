class AttendeeSlotCountsCannotBeNil < ActiveRecord::Migration
  def self.up
    change_column :attendee_slots, :max, :integer, :null => false, :default => 0
    change_column :attendee_slots, :min, :integer, :null => false, :default => 0
    change_column :attendee_slots, :preferred, :integer, :null => false, :default => 0
  end

  def self.down
    change_column :attendee_slots, :max, :integer, :null => true, :default => nil
    change_column :attendee_slots, :min, :integer, :null => true, :default => nil
    change_column :attendee_slots, :preferred, :integer, :null => true, :default => nil
  end
end
