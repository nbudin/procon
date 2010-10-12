class SignupController < ApplicationController
  before_filter :load_event
  
  def index
    @person = current_person
    @upcoming = Event.find(:all, :conditions => ["start > ?", Time.now], :order => "start, end")
  end
  
  def signup
    @hide_chrome = true

    @att = @event.attendances.new(params[:attendance])
    @att.is_waitlist = (@event.kind_of?(LimitedCapacityEvent) and @event.full_for_gender?(@att.gender))
    @att.counts = !@att.is_waitlist
    
    if @event.attendees_visible && (params[:acknowledge_attendees_visible].blank? || !@att.public_info_complete?)
      return redirect_to(form_signup_event_path(@event, :attendance => params[:attendance]))
    end

    begin
      @att.save!
    rescue StandardError => err
      flash[:error_messages] = "You can't sign up for that event.  Reason: \"#{err}\""
    end
  end
  
  def dropout
    def recursive_drop(person, event)
      # disabled recursive drops for now until I figure out better UI for it
      #event.children.each do |c|
      #  recursive_drop(person, c)
      #end
      attendance = Attendance.find_by_person_id_and_event_id person.id, event.id
      if not attendance.nil?
        attendance.destroy
      end
    end
    
    @person = current_person
    @event = Event.find params[:event]
    recursive_drop @person, @event
    redirect_to request.env['HTTP_REFERER']
  end
  
  def success
  end
  
  def form
    @attendance = @event.attendances.new(params[:attendance])
  end
  
  private
  def load_event
    @event = Event.find params[:event_id]
  end
end
