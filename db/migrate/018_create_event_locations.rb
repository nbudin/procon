class CreateEventLocations < ActiveRecord::Migration
  def self.up
    create_table :event_locations do |t|
      t.column :event_id, :integer
      t.column :location_id, :integer
      t.column :exclusive, :boolean, :default => true
    end
  end

  def self.down
    drop_table :event_locations
  end
end
