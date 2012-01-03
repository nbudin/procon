class AddAncestryToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :ancestry, :string
    add_index :locations, :ancestry
    Location.reset_column_information

    Location.build_ancestry_from_parent_ids!
    Location.check_ancestry_integrity!

    remove_column :locations, :parent_id
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration.new
  end
end
