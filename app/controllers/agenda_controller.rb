class AgendaController < ApplicationController
  access_control do
    allow :superadmin
    allow :effective_staff, :of => :context, :to => [:attendees]
    allow logged_in, :to => [:index]
  end
  
  def index
  end
  
  def attendees
    @attendees = @context.all_attendees
    @attendees = sort_people(@attendees)
  end
end
