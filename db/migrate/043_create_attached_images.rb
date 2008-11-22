class CreateAttachedImages < ActiveRecord::Migration
  def self.up
    create_table :attached_images do |t|
      t.column :image_file_name, :string
      t.column :image_content_type, :string
      t.column :image_file_size, :integer
      t.column :image_created_at, :timestamp
      t.column :image_updated_at, :timestamp
      t.column :site_template_id, :integer
      t.timestamps
    end
  end

  def self.down
    drop_table :attached_images
  end
end
