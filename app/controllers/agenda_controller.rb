class AgendaController < ApplicationController
  before_filter :authenticate_person!
  
  def index
  end
  
  def attendees
    authorize! :view_attendees, context
    @attendees = @context.attendances.for_agenda.confirmed.map(&:person)
    @attendees = sort_people(@attendees)
  end
end
