class ProposedEvent < Event
  belongs_to :proposer, :class_name => "Person"

  alias_method :attendance_invalid_if_event_accepted?, :attendance_invalid?
  def attendance_invalid?(att)
    unless att.is_staff
      return "This event proposal has not yet been accepted.  Please wait until it is to sign up."
    end

    return attendance_invalid_if_event_accepted?(att)
  end

  alias_method :has_edit_permissions_without_proposer_check?, :has_edit_permissions?
  def has_edit_permissions?(person)
    if has_edit_permissions_without_proposer_check?(person)
      return true
    else
      if person == proposer
        return true
      end
    end
    return false
  end
end