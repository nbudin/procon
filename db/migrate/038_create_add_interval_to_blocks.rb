class CreateAddIntervalToBlocks < ActiveRecord::Migration
  def self.up
    add_column "schedule_blocks", "interval", :integer
  end

  def self.down
    remove_column "schedule_blocks", "interval"
  end
end
