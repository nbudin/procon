class Attendance < ActiveRecord::Base
  belongs_to :person
  belongs_to :event
  acts_as_paranoid
  
  has_many :public_info_values
  
  validates_uniqueness_of :person_id, :scope => :event_id, :message => "is already attending that event."
  after_destroy :pull_from_waitlist
  
  def validate
    event.attendance_errors(self).each do |err|
      errors.add_to_base err
    end
  end
  
  def status
    if is_staff
      "Staff"
    elsif is_waitlist
      "Waitlisted"
    elsif not counts
      "Not counted"
    elsif event.kind_of? LimitedCapacityEvent
      "Confirmed"
    else
      nil
    end
  end
  
  def pull_from_waitlist
    if not event.kind_of? LimitedCapacityEvent
      return
    end
    
    event.pull_from_waitlist
  end
  
  def age
    person.age_as_of event.start
  end
  
  def value_for_public_info_field(field)
    public_info_values.find_by_public_info_field_id(field.id)
  end
end