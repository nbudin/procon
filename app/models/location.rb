class Location < ActiveRecord::Base
  has_ancestry
  has_many :event_locations, :dependent => :destroy
  has_many :events, :through => :event_locations, :dependent => :destroy
  
  scope :exclusive, :include => :event_locations, :conditions => [ "event_locations.exclusive = ?", true ]
  scope :shareable, :include => :event_locations, :conditions => [ "event_locations.exclusive = ?", false ]
  
  def self.roots_from_set(locs)
    locs.reject { |l| locs.include? l.parent }
  end
end
