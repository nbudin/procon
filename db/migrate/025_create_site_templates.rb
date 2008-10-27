class CreateSiteTemplates < ActiveRecord::Migration
  def self.up
    create_table :site_templates do |t|
      t.column :name, :string, :null => false
      t.column :css, :text
      t.column :header, :text
      t.column :footer, :text
    end
  end

  def self.down
    drop_table :site_templates
  end
end
