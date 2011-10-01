class Location < ActiveRecord::Base
  acts_as_tree :order => "name"
  has_many :event_locations, :dependent => :destroy
  has_many :events, :through => :event_locations, :dependent => :destroy
  
  def self.roots(locs)
    locs.reject { |l| locs.include? l.parent }
  end
end
