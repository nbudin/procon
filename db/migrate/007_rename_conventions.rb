class RenameConventions < ActiveRecord::Migration
  def self.up
    rename_table "conventions", "events"
    rename_table "conventions_people", "events_people"
    rename_column "events_people", "convention_id", "event_id"
  end

  def self.down
    rename_column "events_people", "event_id", "convention_id"
    rename_table "events_people", "conventions_people"
    rename_table "events", "conventions"
  end
end
