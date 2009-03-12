class AddIndexOnCounts < ActiveRecord::Migration
  def self.up
    add_index :attendances, :counts
  end

  def self.down
    remove_index :attendances, :counts
  end
end
