class AttendeeSlot < ActiveRecord::Base
  belongs_to :event
  validates_uniqueness_of :gender, :scope => :event_id

  after_save do |record|
    record.event.pull_from_waitlist
  end
  
  def validate
    kickout = false
    event.attendances.each do |att|
      if err = event.attendance_over_limit?(att)
        kickout = true
        break
      end
    end
    if kickout
      errors.add_to_base "That would kick one or more confirmed attendees out of this event."
    end
  end
  
  def gendered?
  	not (gender.nil? or gender == 'neutral')
  end
  
  def count
    if not gendered?
      # sum other slots and take what's left
      total = event.attendee_slots.reject { |s| s == self }.inject(0) do |i, slot|
        i + slot.count
      end
      event.attendee_count - total
    else
      count = event.attendee_count gender
      
      # don't go over max
      if count > max
        return max
      else
        return count
      end
    end
  end
  
  def full?
    count >= max
  end
  
  def at_min?
    count >= min
  end
  
  def at_preferred?
    count >= preferred
  end
end
