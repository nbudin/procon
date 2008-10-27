class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.column :name, :string, :null => false
      t.column :parent_id, :integer
    end
  end

  def self.down
    drop_table :locations
  end
end
