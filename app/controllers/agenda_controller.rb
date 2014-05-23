class AgendaController < ApplicationController
  before_filter :authenticate_person!
  skip_authorization_check :only => :index
  
  def index
  end
  
  def attendees
    authorize! :view_attendees, @context
    
    @attendees = @context.all_attendees
    attendances = Attendance.all(
      :conditions => {
        :attendances => { :person_id => @attendees.map(&:id) }, 
        :events => { :parent_id => @context.id } 
      }, 
      :include => {:event => [:locations, :virtual_sites]},
      :joins => :event)
    @attendances_by_person_id = attendances.group_by(&:person_id)
    @attendees = sort_people(@attendees)
  end
end
