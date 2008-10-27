class RenameEventsPeople < ActiveRecord::Migration
  def self.up
    rename_table "events_people", "attendances"
  end

  def self.down
    rename_table "attendances", "events_people"
  end
end
