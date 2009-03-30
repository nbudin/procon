class CreateStaffPositions < ActiveRecord::Migration
  def self.up
    create_table :staff_positions do |t|
      t.integer :event_id
      t.string :name
      t.boolean :publish_email, :default => true
      t.integer :position
      t.timestamps
    end
    add_column :attendances, :staff_position_id, :integer
  end

  def self.down
    remove_column :attendances, :staff_position_id
    drop_table :staff_positions
  end
end
