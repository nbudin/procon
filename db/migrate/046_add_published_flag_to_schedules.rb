class AddPublishedFlagToSchedules < ActiveRecord::Migration
  def self.up
    add_column :schedules, :published, :boolean
    Schedule.find(:all).each do |s|
      s.published = true
      s.save
    end
  end

  def self.down
    remove_column :schedules, :published
  end
end
