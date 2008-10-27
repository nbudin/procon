class CreateScheduleBlocks < ActiveRecord::Migration
  def self.up
    create_table :schedule_blocks do |t|
      t.integer :schedule_id
      t.datetime :start
      t.datetime :end
      t.timestamps
    end
    
    create_table :events_schedule_blocks, :id => false do |t|
      t.integer :event_id
      t.integer :schedule_block_id
    end
  end

  def self.down
    drop_table :events_schedule_blocks
    drop_table :schedule_blocks
  end
end
