class AllowVirtualSiteEventToBeNull < ActiveRecord::Migration
  def self.up
    change_column_null :virtual_sites, :event_id, true
  end

  def self.down
    change_column_null :virtual_sites, :event_id, false
  end
end
