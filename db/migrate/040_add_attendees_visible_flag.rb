class AddAttendeesVisibleFlag < ActiveRecord::Migration
  def self.up
    add_column "events", "attendees_visible", :boolean, :default => false
  end

  def self.down
    remove_column "events", "attendees_visible"
  end
end
