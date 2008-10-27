class AssociateSchedulesWithEvents < ActiveRecord::Migration
  def self.up
    add_column "schedules", "event_id", :integer
  end

  def self.down
    remove_column "schedules", "event_id"
  end
end
