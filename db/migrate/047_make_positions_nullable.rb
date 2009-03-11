class MakePositionsNullable < ActiveRecord::Migration
  def self.up
    change_column :registration_buckets, :position, :integer, :null => true
    change_column :registration_rules, :position, :integer, :null => true
  end

  def self.down
    change_column :registration_buckets, :position, :integer, :null => false
    change_column :registration_rules, :position, :integer, :null => false
  end
end
