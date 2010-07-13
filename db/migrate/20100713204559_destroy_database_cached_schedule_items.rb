class DestroyDatabaseCachedScheduleItems < ActiveRecord::Migration
  def self.up
    drop_table :events_schedule_blocks
    drop_table :schedule_blocks
    drop_table :schedule_blocks_tracks
    drop_table :scheduled_event_positions
  end

  def self.down
    create_table "events_schedule_blocks", :id => false, :force => true do |t|
      t.integer "event_id"
      t.integer "schedule_block_id"
    end
    
    create_table "schedule_blocks", :force => true do |t|
      t.integer  "schedule_id"
      t.datetime "start"
      t.datetime "end"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer  "interval"
    end

    create_table "schedule_blocks_tracks", :id => false, :force => true do |t|
      t.integer "track_id"
      t.integer "schedule_block_id"
    end

    create_table "scheduled_event_positions", :force => true do |t|
      t.integer  "schedule_block_id"
      t.integer  "event_id"
      t.float    "left"
      t.float    "top"
      t.float    "width"
      t.float    "height"
      t.string   "color"
      t.datetime "created_at"
      t.datetime "updated_at"
    end
  end
end
