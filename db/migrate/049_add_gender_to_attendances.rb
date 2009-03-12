class AddGenderToAttendances < ActiveRecord::Migration
  def self.up
    add_column :attendances, :gender, :string
    add_index :attendances, :gender

    Attendance.find(:all).each do |att|
      if att.person
        att.gender = att.person.gender
        att.save!
      end
    end
  end

  def self.down
    remove_column :attendances, :gender
  end
end
