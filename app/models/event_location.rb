class EventLocation < ActiveRecord::Base
  belongs_to :event
  belongs_to :location
  scope :exclusive, :conditions => {:exclusive => true}
  scope :shareable, :conditions => {:exclusive => false}
  
  validates_uniqueness_of :location_id, :scope => :event_id, :message => "is already booked for that event."
  
  validate do |loc|
    if not loc.event.parent.nil?
      if not loc.event.parent.locations.include? location
        loc.errors.add_to_base "That location is not available to this event because " +
          "\"#{event.parent.fullname}\" has not booked it."
      end
    end
    
    if loc.exclusive && loc.event.simultaneous.events.any? { |e| e.locations.include? location }
      loc.errors.add_to_base "This location is already being used during that time by the event " +
        "\"#{e.fullname}\"."
    end
  end
end
