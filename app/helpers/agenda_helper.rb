module AgendaHelper
  def context_events(person)
    Attendance.find_all_by_person_id(person.id, :include => :event, :order => "start").select do |a|
      e = a.event
      (not e.nil?) and (@context.nil? or e.parent == @context)
    end
  end
end
