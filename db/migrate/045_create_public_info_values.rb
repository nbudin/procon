class CreatePublicInfoValues < ActiveRecord::Migration
  def self.up
    create_table :public_info_values do |t|
      t.column :public_info_field_id, :integer
      t.column :attendance_id, :integer
      t.column :value, :string
      t.timestamps
    end
    add_index :public_info_values, :public_info_field_id
    add_index :public_info_values, :attendance_id
  end

  def self.down
    drop_table :public_info_values
  end
end
