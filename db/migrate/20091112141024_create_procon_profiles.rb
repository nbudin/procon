class CreateProconProfiles < ActiveRecord::Migration
  def self.up
    create_table :procon_profiles do |t|
      t.integer :person_id
      t.string :nickname
      t.string :phone
      t.string :best_call_time
    end
  end

  def self.down
    drop_table :procon_profiles
  end
end
