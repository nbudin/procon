class WaitlistToRegularAttendance < ActiveRecord::Migration
  def self.up
    add_column :attendances, :is_waitlist, :boolean, :default => false
    WaitlistAttendance.find(:all).each do |wa|
      att = Attendance.create :person => wa.person, :event => wa.event, :counts => false,
        :is_waitlist => true
    end
    drop_table :waitlist_attendances
  end

  def self.down
    create_table "waitlist_attendances", :force => true do |t|
      t.column "event_id",   :integer
      t.column "person_id",  :integer
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "counts",     :boolean,  :default => true
      t.column "is_staff",   :boolean
    end
    Attendance.find_all_by_is_waitlist(true).each do |att|
      wa = WaitlistAttendance.create :person => att.person, :event => :att.event
      att.destroy
    end
    remove_column :attendances, :is_waitlist
  end
end
