module AgendaHelper
  def context_events(person, attendances=nil)
    attendances ||= Attendance.find_all_by_person_id(person.id, :include => :event, :joins => :event)
    attendances.sort_by { |att| att.event.start || Time.at(0) }.select do |a|
      e = a.event
      (not e.nil?) and (not e.kind_of?(ProposedEvent)) and (@context.nil? or e.parent == @context)
    end
  end
end
