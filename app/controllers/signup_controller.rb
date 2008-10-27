class SignupController < ApplicationController
  def index
    @person = logged_in_person
    @upcoming = Event.find(:all, :conditions => ["start > ?", Time.now], :order => "start, end")
  end
  
  def signup
    @person = logged_in_person
    @event = Event.find params[:event]
    att = Attendance.new :person => @person, :event => @event, :is_waitlist => false, :counts => true
    begin
      att.save!
    rescue StandardError => err
      flash[:error_messages] = "You can't sign up for that event.  Reason: \"#{err}\""
    end
    redirect_to request.env['HTTP_REFERER']
  end
  
  def signup_for_waitlist
    @person = logged_in_person
    @event = Event.find params[:event]
    att = Attendance.create :person => @person, :event => @event, :is_waitlist => true, :counts => false
    begin
      att.save!
    rescue StandardError => err
      flash[:error_messages] = "You can't sign up for that event.  Reason: \"#{err}\""
    end
    redirect_to request.env['HTTP_REFERER']
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
    
    @person = logged_in_person
    @event = Event.find params[:event]
    recursive_drop @person, @event
    redirect_to request.env['HTTP_REFERER']
  end
  
  def success
  end
  
  def form
    @event = Event.find params[:event]

    if not @event.nil?
      @event.attendances.create :person => @person
      @event.save
    end
  end
end
