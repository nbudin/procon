class AgendaController < ApplicationController
  before_filter :authenticate_person!
  
  def index
    @attendances = current_person.attendances.in_context(context).for_agenda.confirmed.time_ordered
    @past = @attendances.select { |att| att.event.end && att.event.end < Time.now }
    @current = @attendances.reject { |att| @past.include?(att) }.select { |att| att.event.start && att.event.start < Time.now }
    @upcoming = @attendances.reject { |att| @past.include?(att) || @current.include?(att) }
  end
  
  def attendees
    authorize! :view_attendees, context
    @attendees = Person.attending(context)
    @attendees = sort_people(@attendees)
    
    @attendances = {}
    Attendance.by_person_id(@attendees.map(&:id)).in_context(context).for_agenda.confirmed.time_ordered.each do |att|
      next unless att.person
      
      @attendances[att.person] ||= []
      @attendances[att.person] << att
    end
  end
end
