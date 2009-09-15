class AddNameToVirtualSites < ActiveRecord::Migration
  def self.up
    add_column :virtual_sites, :name, :string
  end

  def self.down
    remove_column :virtual_sites, :name, :string
  end
end
