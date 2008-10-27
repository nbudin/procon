class CreateVirtualSites < ActiveRecord::Migration
  def self.up
    create_table "virtual_sites" do |t|
      t.column "event_id", :integer, :null => false
      t.column "domain", :string, :null => false
      t.column "site_template_id", :integer
    end
    add_index "virtual_sites", "domain"
    add_index "virtual_sites", "event_id"
  end

  def self.down
    drop_table :virtual_sites
  end
end
