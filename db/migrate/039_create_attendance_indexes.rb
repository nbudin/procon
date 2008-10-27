class CreateAttendanceIndexes < ActiveRecord::Migration
  def self.up
    add_index(:attendances, :event_id)
    add_index(:attendances, :person_id)
    add_index(:attendances, :deleted_at)
    add_index(:attendee_slots, :event_id)
  end

  def self.down
    remove_index(:attendances, :event_id)
    remove_index(:attendances, :person_id)
    remove_index(:attendances, :deleted_at)
    remove_index(:attendee_slots, :event_id)
  end
end
