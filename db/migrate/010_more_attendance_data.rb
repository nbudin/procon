class MoreAttendanceData < ActiveRecord::Migration
  def self.up
    add_column "attendances", "counts", :boolean, :default => true
    add_column "attendances", "is_staff", :boolean
  end

  def self.down
    remove_column "attendances", "is_staff"
    remove_column "attendances", "counts"
  end
end
