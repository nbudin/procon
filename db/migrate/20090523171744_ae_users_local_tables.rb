class AeUsersLocalTables < ActiveRecord::Migration
  def self.up
    create_table :accounts do |t|
      t.column :password, :string
      t.column :active, :boolean
      t.column :activation_key, :string
      t.column :person_id, :integer
      t.timestamps
    end
    
    create_table :email_addresses do |t|
      t.column :address, :string
      t.column :primary, :boolean
      t.column :person_id, :integer
      t.timestamps
    end
    
    create_table :groups do |t|
      t.column :name, :string
    end
    
    create_table :groups_people, :id => false do |t|
      t.column :person_id, :integer, :null => false
      t.column :group_id, :integer, :null => false
    end
    
    create_table :open_id_identities do |t|
      t.column :person_id, :integer
      t.column :identity_url, :string, :limit => 4000
    end
    
    create_table :people do |t|
      t.column :firstname, :string
      t.column :lastname, :string
      t.column :gender, :string
      t.column :birthdate, :datetime
      t.timestamps
    end
    
    create_table :auth_tickets do |t|
      t.column :secret, :string
      t.column :person_id, :integer
      t.timestamps
      t.column :expires_at, :datetime
    end

    add_index :auth_tickets, :secret, :unique => true
  end

  def self.down
    drop_table :auth_tickets
    drop_table :people
    drop_table :open_id_identities
    drop_table :groups_people
    drop_table :groups
    drop_table :email_addresses
    drop_table :accounts
  end
end
