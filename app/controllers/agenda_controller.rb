class AgendaController < ApplicationController
  before_filter :check_logged_in
  
  def index
    @attendances = logged_in_person.app_profile.attendances.select do |a|
      e = a.event
      (not e.nil?) and (@context.nil? or e.parent == @context)
    end
  end
  
  def check_logged_in
    if not logged_in?
      redirect_to :controller => :main, :action => :index
    end
  end
end
