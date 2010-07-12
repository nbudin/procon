class Location < ActiveRecord::Base
  acts_as_tree :order => "name"
  has_many :event_locations, :dependent => :destroy
  has_many :events, :through => :event_locations, :dependent => :destroy
  
  scope :exclusive, :include => :event_locations, :conditions => [ "event_locations.exclusive = ?", true ]
  scope :shareable, :include => :event_locations, :conditions => [ "event_locations.exclusive = ?", false ]
  
  def self.roots(locs)
    roots = locs.dup
    redundant = roots.select { |l| roots.include? l.parent }
    roots -= redundant
    return roots
  end
end
