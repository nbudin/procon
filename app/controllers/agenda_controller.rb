class AgendaController < ApplicationController
  before_filter :check_logged_in
  before_filter :check_view_permissions, :only => [:attendees]
  
  def index
  end
  
  def attendees
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

  private
  def check_logged_in
    if not logged_in?
      redirect_to :controller => :main, :action => :index
    end
  end

  def check_view_permissions
    if @context.nil?
      flash[:error_messages] = ["You must be on an event's virtual site to use this function."]
      redirect_to "/"
    end

    if @context.attendees_visible_to?(logged_in_person)
      return
    end
    flash[:error_messages] = ["You aren't permitted to perform that action.  Please log into an account that has permissions to do that."]
    redirect_to "/"
  end
end
