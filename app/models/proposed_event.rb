class ProposedEvent < Event
  belongs_to :proposer, :class_name => "Person"

  def attendance_invalid?(att)
    unless att.is_staff
      return "This event proposal has not yet been accepted.  Please wait until it is to sign up."
    end

    return super(att)
  end
end
