class AddEmailToStaffPositions < ActiveRecord::Migration
  def self.up
    add_column :staff_positions, :email, :string
  end

  def self.down
    remove_column :staff_positions, :email
  end
end
