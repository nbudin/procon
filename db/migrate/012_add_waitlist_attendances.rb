class AddWaitlistAttendances < ActiveRecord::Migration
  def self.up
    create_table "waitlist_attendances", :force => true do |t|
      t.column "event_id",   :integer
      t.column "person_id",  :integer
      t.column "created_at", :datetime
      t.column "updated_at", :datetime
      t.column "counts",     :boolean,  :default => true
      t.column "is_staff",   :boolean
    end
  end

  def self.down
    drop_table "waitlist_attendances"
  end
end
