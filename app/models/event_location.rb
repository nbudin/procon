class EventLocation < ActiveRecord::Base
  belongs_to :event
  belongs_to :location
  
  validates_uniqueness_of :location_id, :scope => :event_id, :message => "is already booked for that event."
  
  def validate
    if not event.parent.nil?
      if not event.parent.locations.include? location
        errors.add_to_base "That location is not available to this event because " +
          "\"#{event.parent.fullname}\" has not booked it."
      end
    end
    
    if exclusive
      event.simultaneous_events.each do |e|
        if e.locations.include? location
          errors.add_to_base "This location is already being used during that time by the event " +
            "\"#{e.fullname}\"."
        end
      end
    end
  end
end
