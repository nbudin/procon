module AttendancesHelper
  def attendance_class(attendance)
    if attendance.deleted_at
      "drop"
    elsif attendance.is_waitlist?
      "waitlist"
    elsif attendance.counts?
      "confirmed"
    else
      "uncounted"
    end
  end
end
