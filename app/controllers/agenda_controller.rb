class AgendaController < ApplicationController
  before_filter :authenticate_person!
  before_filter :check_view_permissions, :only => [:attendees]
  skip_authorization_check :only => :index
  
  def index
  end
  
  def attendees
    authorize! :view_attendees, @context
    
    @attendees = @context.all_attendees
    @attendees = sort_people(@attendees)
  end
end
