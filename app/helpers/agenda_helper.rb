module AgendaHelper
  def context_events(person)
    Attendance.find_all_by_person_id(person.id, :include => :event, :joins => :event, :order => "start").select do |a|
      e = a.event
      (not e.nil? or e.kind_of?(ProposedEvent)) and (@context.nil? or e.parent == @context)
    end
  end
end
