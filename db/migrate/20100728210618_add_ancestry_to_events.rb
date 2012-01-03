class AddAncestryToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :ancestry, :string
    add_index :events, :ancestry
    Event.reset_column_information

    Event.build_ancestry_from_parent_ids!
    Event.check_ancestry_integrity!

    remove_column :events, :parent_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
