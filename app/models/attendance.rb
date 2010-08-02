class Attendance < ActiveRecord::Base
  belongs_to :person
  belongs_to :event
  belongs_to :staff_position
  
  scope :existent, lambda { where(["attendances.deleted_at is NULL or attendances.deleted_at > ?", Time.now]) }
  scope :confirmed, where(:is_waitlist => false)
  scope :waitlist, where(:is_waitlist => true)
  default_scope existent
  
  scope :by_person_id, lambda { |person_id| where(:person_id => person_id) }
  scope :in_context, lambda { |context| joins(:event).where("events.id IN (#{Event.descendants_of(context).select(:id).to_sql})") }
  scope :for_agenda, includes( :person => [], :event => [:virtual_sites, :locations] )
  scope :time_ordered, joins(:event).order("events.start, events.end")
  
  scope :in_any_descendant, lambda { |event| 
    where(["event_id IN (?)", event.descendants.map(&:id)])
    }
  scope :not_in_any_descendant, lambda { |event|
    where("person_id NOT IN (#{in_any_descendant(event).select("attendances.person_id").to_sql})") 
    }

  def self.dropped_from(event)
    unscoped.where(["deleted_at < ? and event_id = ?", Time.now, event.id])
  end
  
  has_many :public_info_values
  
  validates_uniqueness_of :person_id, :scope => :event_id, :message => "is already attending that event."
  after_destroy :pull_from_waitlist
  after_save do |record|
    record.pull_from_waitlist if record.deleted?
  end

  validates_presence_of :person
  validates_inclusion_of :gender, :in => ["male", "female"]

  before_validation :ensure_gender_set
  after_save :check_waitlist
  
  scope :waitlist, :conditions => { :is_waitlist => true }
  scope :counted, :conditions => { :counts => true }
  
  def deleted?
    deleted_at && deleted_at <= Time.now
  end
  
  validate do |att|
    unless att.event.nil?
      att.event.attendance_errors(att).each do |err|
        att.errors.add_to_base err
      end
    end
  end
  
  def status
    if person.staffer_for_event(event)
      "Staff"
    elsif is_waitlist
      "Waitlisted"
    elsif not counts
      "Not counted"
    else
      "Confirmed"
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
