class Location < ActiveRecord::Base
  acts_as_tree :order => "name"
  has_many :event_locations, :dependent => :destroy
  has_many :events, :through => :event_locations, :dependent => :destroy
end
