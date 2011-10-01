class AddProposedEventIdToEvents < ActiveRecord::Migration
  def self.up
    change_table :events do |t|
      t.integer :proposed_event_id
    end
    add_index :events, :proposed_event_id
  end

  def self.down
    remove_column :events, :proposed_event_id
  end
end
