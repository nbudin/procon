class CreateScheduledEventPositions < ActiveRecord::Migration
  def self.up
    create_table :scheduled_event_positions do |t|
      t.integer :schedule_block_id
      t.integer :event_id
      t.float :left
      t.float :top
      t.float :width
      t.float :height
      t.string :color
      t.timestamps
    end
    create_table :schedule_blocks_tracks, :id => false do |t|
      t.integer :track_id
      t.integer :schedule_block_id
    end
  end

  def self.down
    drop_table :schedule_blocks_tracks
    drop_table :scheduled_event_positions
  end
end
