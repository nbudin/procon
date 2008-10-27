class CreateConventionsPeople < ActiveRecord::Migration
  def self.up
    create_table :conventions_people do |t|
      t.column :convention_id, :integer
      t.column :person_id, :integer
      t.column :created_at, :datetime
      t.column :updated_at, :datetime
    end
  end

  def self.down
    drop_table :conventions_people
  end
end
