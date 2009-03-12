class AddGenderToAttendances < ActiveRecord::Migration
  def self.up
    add_column :attendances, :gender, :string
    add_index :attendances, :gender

    Attendance.find(:all).each do |att|
      if att.person
        att.gender = att.person.gender
        if not att.save
          att.errors.each do |attr, msg|
            puts "WARNING: Attendance #{att.id} failed validation - #{attr}: #{msg}\n"
          end
        end
      end
    end
  end

  def self.down
    remove_column :attendances, :gender
  end
end
