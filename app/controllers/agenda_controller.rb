class AgendaController < ApplicationController
  before_filter :authenticate_person!
  
  def index
  end
  
  def attendees
    authorize! :view_attendees, context
    @attendees = @context.all_attendees
    @attendees = sort_people(@attendees)
  end
end
