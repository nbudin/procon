class CreateConventions < ActiveRecord::Migration
  def self.up
    create_table :conventions do |t|
      t.column :fullname, :string, :null => false
      t.column :shortname, :string
      t.column :number, :string
      t.column :start, :datetime
      t.column :end, :datetime
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :conventions
  end
end
