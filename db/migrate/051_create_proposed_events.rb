class CreateProposedEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :proposed_timing, :text
    add_column :events, :proposal_comments, :text
    add_column :events, :proposed_location, :text
    add_column :events, :proposed_capacity_limits, :text
    add_column :events, :proposer_id, :integer
  end

  def self.down
    remove_column :events, :proposed_timing
    remove_column :events, :proposal_comments
    remove_column :events, :proposed_location
    remove_column :events, :proposed_capacity_limits
    remove_column :events, :proposer_id
  end
end
