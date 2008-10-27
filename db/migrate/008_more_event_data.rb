class MoreEventData < ActiveRecord::Migration
  def self.up
    add_column "events", "type", :string
    add_column "events", "blurb", :string, :limit => 4000
    add_column "events", "description", :string, :limit => 4000
    add_column "events", "parent_id", :integer
  end

  def self.down
    remove_column "events", "parent_id"
    remove_column "events", "description"
    remove_column "events", "blurb"
    remove_column "events", "type"
  end
end
