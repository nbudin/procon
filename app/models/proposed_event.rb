class ProposedEvent < Event
  belongs_to :proposer, :class_name => "Person"
  has_one :event

  alias_method :attendance_invalid_if_event_accepted?, :attendance_invalid?
  def attendance_invalid?(att)
    unless att.is_staff
      return "This event proposal has not yet been accepted.  Please wait until it is to sign up."
    end

    return attendance_invalid_if_event_accepted?(att)
  end
end
