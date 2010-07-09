require 'ae_users_migrator/import'

class CreatePeople < ActiveRecord::Migration
  class ProconProfile < ActiveRecord::Base
  end
  
  class Permission < ActiveRecord::Base
  end
  
  def self.up
    create_table :people do |t|
      t.string :email
      t.string :firstname
      t.string :lastname
      t.string :gender
      t.timestamp :birthdate
      
      t.string :nickname
      t.string :phone
      t.string :best_call_time
      t.boolean :admin

      t.cas_authenticatable
      t.trackable
      t.timestamps
    end

    add_index :people, :username, :unique => true
    
    person_ids = Attendance.group(:person_id).map(&:person_id)
    person_ids += ProconProfile.group(:person_id).map(&:person_id)
    person_ids += Event.group(:proposer_id).map(&:proposer_id)
    person_ids += Permission.group(:person_id).map(&:person_id)
    person_ids = person_ids.uniq.compact
    
    role_ids = Permission.group(:role_id).map(&:role_id)
    role_ids = role_ids.uniq.compact
    
    if person_ids.count > 0 or role_ids.count > 0
      unless File.exist?("ae_users.json")
        raise "There are users to migrate, and ae_users.json does not exist.  Please use export_ae_users.rb to create it."
      end
      dumpfile = AeUsersMigrator::Import::Dumpfile.load(File.new("ae_users.json"))

      merged_person_ids = {}
            
      role_ids.each do |role_id|
        person_ids += dumpfile.roles[role_id].people.map(&:id)
      end
      person_ids = person_ids.uniq.compact
      
      say "Migrating #{person_ids.size} existing people from ae_users"
      
      person_ids.each do |person_id|
        person = dumpfile.people[person_id]
        if person.nil?
          say "Person ID #{person_id.inspect} not found in ae_users.json!  Dangling references may be left in database."
          next
        end
        
        if person.primary_email_address.nil?
          say "Person ID #{person.id} (#{person.firstname} #{person.lastname}) has no primary email address!  Cannot create, so dangling references may be left in database."
          next
        end
        
        merge_into = Person.find_by_username(person.primary_email_address.address)
        if merge_into.nil?
          pr = Person.new(:firstname => person.firstname, :lastname => person.lastname, 
            :email => person.primary_email_address.address, :gender => person.gender, :birthdate => person.birthdate,
            :username => person.primary_email_address.address)
          pr.id = person.id
          pr.save!
        else
          say "Person ID #{person.id} (#{person.firstname} #{person.lastname}) has an existing email address.  Merging into ID #{merge_into.id} (#{person.firstname} #{person.lastname})."
          merged_person_ids[person.id] = merge_into.id
        end
      end
            
      execute %{ update people, procon_profiles 
        set people.nickname = procon_profiles.nickname, 
            people.best_call_time = procon_profiles.best_call_time,
            people.phone = procon_profiles.phone
        where procon_profiles.person_id = people.id
      }
      
      merged_person_ids.each do |from_id, to_id|
        merge_into = Person.find(to_id)
        count = merge_into.merge_person_id!(from_id)
        say "Merged #{count} existing records for person ID #{from_id}"
      end
      
      Permission.where("permission is null and permissioned_id is null").each do |perm|
        say "Found admin permission #{perm.inspect}"
        
        admins = []
        if perm.person_id
          if merged_person_ids[perm.person_id]
            admins << Person.find(merged_person_ids[perm.person_id])
          else
            admins << Person.find(perm.person_id)
          end
        elsif perm.role_id
          admins += Person.where(:id => dumpfile.roles[perm.role_id].people.map(&:id)).all
        end
        
        admins.each do |person|
          say "Granting admin rights to #{person.name}"
          person.admin = true
          person.save!
        end
      end
      
      drop_table :permissions
      drop_table :open_id_authentication_associations
      drop_table :open_id_authentication_nonces
      drop_table :permission_caches
      drop_table :procon_profiles
    end
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
