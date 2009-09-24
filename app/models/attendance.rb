class Attendance < ActiveRecord::Base
  belongs_to :person
  belongs_to :event
  belongs_to :staff_position
  acts_as_paranoid
  
  has_many :public_info_values
  
  validates_uniqueness_of :person_id, :scope => :event_id, :message => "is already attending that event."
  after_destroy :pull_from_waitlist

  validates_presence_of :person
  validates_inclusion_of :gender, :in => ["male", "female"]

  before_validation :ensure_gender_set
  after_save :check_waitlist
  
  named_scope :staff, :conditions => { :is_staff => true }
  named_scope :waitlist, :conditions => { :is_waitlist => true }
  named_scope :counted, :conditions => { :counts => true }
  
  def validate
    unless event.nil?
      event.attendance_errors(self).each do |err|
        errors.add_to_base err
      end
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

  private
  def ensure_gender_set
    if self.gender.nil? and self.person
      self.gender = self.person.gender
    end
  end

  def check_waitlist
    if self.event.kind_of? LimitedCapacityEvent
      if not self.event.full? and self.event.waitlist_attendees.size > 0
        self.event.pull_from_waitlist
      end
    end
  end
end
