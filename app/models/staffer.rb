class Staffer < ActiveRecord::Base
  belongs_to :event
  belongs_to :person
  acts_as_list :scope => :event
  validates_uniqueness_of :person_id, :scope => :event_id
  
  scope :in_event_and_ancestors, lambda { |event|
    where(:event_id => ([event] + event.ancestors).map(&:id))
  }
end