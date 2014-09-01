class SignupController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_person!
  
  def signup
    @hide_chrome = true
    @person = current_person
    @event = Event.find params[:event]
    is_waitlist = (@event.kind_of?(LimitedCapacityEvent) and @event.full_for_gender?(@person.gender))
    
    proceed = false
    if (not @event.attendees_visible) or (not params[:acknowledge_attendees_visible].blank?)
      proceed = true
      @event.public_info_fields.each do |field|
        if params[:public_info_field].try(:[], field.id.to_s).blank?
          proceed = false
        end
      end
    end

    if proceed
      @att = Attendance.new :person => @person, :event => @event, :is_waitlist => is_waitlist, :counts => !is_waitlist
      begin
        @att.save!
        @event.public_info_fields.each do |field|
          piv = @att.public_info_values.new :public_info_field => field, :value => params[:public_info_field][field.id.to_s]
          piv.save!
        end
        
        @event.reload if @att.is_waitlist?
      rescue StandardError => err
        flash[:error_messages] = ["You can't sign up for that event.  Reason: \"#{err}\""]
      end
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
    redirect_to (request.env['HTTP_REFERER'] || event_url(@event))
  end
  
  def success
  end
end
