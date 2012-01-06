class AddChildEventMaximumSignups < ActiveRecord::Migration
  def self.up
    add_column :events, :max_child_event_attendances, :integer, :default => nil
    add_column :events, :counts_for_max_attendances, :boolean, :null => false, :default => true
  end

  def self.down
    remove_column :events, :counts_for_max_attendances
    remove_column :events, :max_child_event_attendances
  end
end
