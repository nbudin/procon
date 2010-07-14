module AgendaHelper
  def context_events(person)
    person.attendances.select do |a|
      e = a.event
      (not e.nil?) and (not e.kind_of?(ProposedEvent)) and (@context.nil? or e.parent == @context)
    end.sort_by {|a| a.event.start}
  end
end
