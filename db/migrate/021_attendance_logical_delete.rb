class AttendanceLogicalDelete < ActiveRecord::Migration
  def self.up
    add_column "attendances", "deleted_at", :datetime
  end

  def self.down
    remove_column "attendances", "deleted_at"
  end
end
