class AttendeeSlot < ActiveRecord::Base
  belongs_to :event, :class_name => "LimitedCapacityEvent", :foreign_key => "event_id"
  validates_uniqueness_of :gender, :scope => :event_id
  
  %w{min max preferred}.each do |field|
    class_eval %{
      def #{field}
        read_attribute(:#{field}) || 0
      end
    }
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
  
  def after_save
    event.pull_from_waitlist
  end
  
  def gendered?
  	not (gender.nil? or gender == 'neutral')
  end
  
  def count
    if not gendered?
      # sum other slots and take what's left
      total = 0
      event.attendee_slots.each do |slot|
        if slot.id != self.id
          total += slot.count
        end
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
