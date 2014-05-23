class MakeBlurbAndDescriptionTextFields < ActiveRecord::Migration
  def self.up
    change_column :events, :blurb, :text
    change_column :events, :description, :text
  end

  def self.down
    change_column :events, :blurb, :string, :limit => 4000
    change_column :events, :description, :string, :limit => 4000
  end
end
