class CreatePublicInfoFields < ActiveRecord::Migration
  def self.up
    create_table :public_info_fields do |t|
      t.column :name, :string
      t.column :event_id, :integer
      t.timestamps
    end
    add_index :public_info_fields, :event_id
  end

  def self.down
    drop_table :public_info_fields
  end
end
