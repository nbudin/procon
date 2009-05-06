class IndexEventLocationsOnEventId < ActiveRecord::Migration
  def self.up
    add_index :event_locations, :event_id
  end

  def self.down
    remove_index :event_locations, :event_id
  end
end
