class NewStaffSchema < ActiveRecord::Migration
  class StaffPosition < ActiveRecord::Base
    belongs_to :event
    acts_as_list :scope => :event
    has_many :attendances
  end
  
  def self.up
    create_table :staffers do |t|
      t.integer :event_id
      t.integer :person_id
      t.string :title
      t.boolean :listed
      t.integer :position
      t.boolean :publish_email
      t.boolean :event_admin
      t.boolean :proposal_admin
      t.boolean :schedule_admin
      t.boolean :attendee_viewer
      t.timestamps
    end
    
    add_index :staffers, :event_id
    
    transaction do
      staff_positions = {}
      StaffPosition.all.each do |spos|
        staff_positions[spos.id] = spos
      end

      Attendance.where(:is_staff => true).all.each do |att|
        say "Migrating #{att.person.name} at #{att.event.shortname} to staffer"
        staffer = Staffer.new(:event => att.event, :person => att.person, :event_admin => true, 
          :proposal_admin => true, :schedule_admin => true, :attendee_viewer => true)
        
        if att.try(:staff_position_id)
          spos = staff_positions[att.staff_position_id]
          if spos
            staffer.listed = true
            staffer.title = spos.name
            staffer.position = spos.position
            staffer.publish_email = spos.publish_email
          end
        end
        
        staffer.save!
      end
    end
    
    remove_column :attendances, :is_staff
    drop_table :staff_positions
  end

  def self.down
    raise ActiveRecord::IrreversibleMigration
  end
end
