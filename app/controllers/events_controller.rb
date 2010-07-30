class EventsController < ApplicationController
  load_and_authorize_resource
  
  def email_list
    @method = if params[:waitlist]
      "waitlist_attendees"
    else
      "confirmed_attendees"
    end
    @event = Event.find(params[:id])
    @attendees = @event.send(@method)
  end
  
  def signup_sheet
    @event = Event.find(params[:id])
    if request.post?
      @options = {}
      @options[:include_scheduling_details] = params[:include_scheduling_details]
      @options[:include_blurb] = params[:include_blurb]
      @options[:include_stafflist] = params[:include_stafflist]
      @options[:empty_slot_min] = params[:empty_slot_min].to_i
      @include_children = params[:include_children]
      @exclude_event = params[:exclude_event]

  	  render :layout => "signup_sheet"
    else
      render :action => "signup_sheet_form"
    end
  end

  def available_people
    @event = Event.find(params[:id])
    @check_events = @event.parent ? @event.parent.children : Event.find(:all)
    @all_people = @event.parent ? @event.parent.all_attendees : People.find(:all)
    @available_people = @all_people.select do |person|
      if not person.procon_profile
        logger.debug "Rejecting #{person.name} due to no profile"
        false
      else
        logger.debug "Evaluating #{person.name} availability"
        not person.procon_profile.busy_between?(@event.start, @event.end, @check_events)
      end
    end
    @available_people = sort_people(@available_people)
  end
  
  def index
    @events = visible_events.reject { |e| e.kind_of? ProposedEvent }
    
    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @events.to_xml }
    end
  end
  
  def new
    @event = Event.new
    if @context
      @event.parent = @context
    end
  end
  
  def create
    @event = Event.new(params[:event])
    if @context
      @event.parent = @context
    end

    save_from_form
  end
  
  def destroy
    @event = Event.find params[:id]
    if params[:sure]
      @event.destroy
      redirect_to events_url
    end
  end
  
  def show
    @event = Event.find params[:id]
    @public_info_fields = @event.public_info_fields

    respond_to do |format|
      format.html # show.rhtml
      format.json { render :json => @event.to_json }
      format.xml  { render :xml => @event.to_xml }
    end
  end
  
  def show_description
    @event = Event.find params[:id]
    @public_info_fields = @event.public_info_fields
    @noninteractive = true
    render :action => "show"
  end
  
  def pull_from_children
    @event = Event.find params[:id]
    @event.pull_from_children
    redirect_to @event
  end
  
  def edit
    @event = Event.find params[:id]
  end
  
  def update
    @event = Event.find params[:id]
    save_from_form
  end

  private
  def save_from_form
    if @event.new_record?
      @event.save
      @event.set_default_registration_policy
    end
    
    flash[:error_messages] ||= []

    if @event.kind_of? ProposedEvent
      unless @event.staffers.any? {|staffer| @event.proposer == staffer.person }
        a = Attendance.new :person => @event.proposer, :event => @event, :is_staff => true, :counts => false
        if not a.save
          flash[:error_messages].push("Could not add the event proposer as a staff member: #{a.errors.full_messages.join(", ")}")
        end
      end
    end
    
    if @event.update_attributes(params[:event]) and flash[:error_messages].length == 0
      respond_to do |format|
        format.html { redirect_to(event_url(@event)) }
        format.json { redirect_to(formatted_event_url(@event, :json)) }
        format.xml  { redirect_to(formatted_event_url(@event, :xml)) }
      end
    else
      flash[:error_messages] += @event.errors.full_messages
      respond_to do |format|
        format.html { redirect_to(edit_event_url(@event)) }
        format.json { render :json => @event.errors.to_json }
        format.xml  { render :xml => @event.errors.to_xml }
      end
    end
  end
  
  def check_event_visibility
    @event = Event.find(params[:id])
    if @event.kind_of? ProposedEvent
      check_edit_permissions
    end
  end
  
  def visible_events
    if @context
      return @context.children
    else
      return Event.find(:all)
    end
  end
end
