class ChangeLongStringsToText < ActiveRecord::Migration
  def self.up
    change_column :events, :description, :text
    change_column :events, :blurb, :text
  end

  def self.down
    change_column :events, :blurb, :string, :limit => 4000
    change_column :events, :description, :string, :limit => 4000    
  end
end
