class CreateTracks < ActiveRecord::Migration
  def self.up
    create_table :tracks do |t|
      t.string :name
      t.integer :position
      t.integer :schedule_id, :null => false
      t.string :color
      
      t.timestamps
    end
    
    create_table :events_tracks, :id => false do |t|
      t.integer :event_id
      t.integer :track_id
    end
  end

  def self.down
    drop_table :events_tracks
    drop_table :tracks
  end
end
