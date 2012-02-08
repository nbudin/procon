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
    calculate_edit_vars
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
    calculate_edit_vars
  end
  
  def update
    @event = Event.find params[:id]
    save_from_form
  end

  def propose
    @event = ProposedEvent.new
    if @context
      @event.parent = @context
    end
    calculate_edit_vars
  end
  
  def submit_proposal
    @event = ProposedEvent.new(params[:event])
    if @context
      @event.parent = @context
    end
    @event.proposer ||= current_person
    save_from_form
  end

  private
  def save_from_form
    if @event.new_record?
      @event.save
      @event.set_default_registration_policy
    end
    
    flash[:error_messages] ||= []
    
    if params[:locations]
      locs = params[:locations]
      @event.event_locations.each do |booking|
        if not locs.include? booking.location.id
          booking.destroy
        end
      end

      locs.each do |locid|
        loc = Location.find(locid)
        if not @event.locations.include? Location.find(locid)
          booking = EventLocation.new(:event => @event, :location => loc, :exclusive => true)
          if not booking.save
            flash[:error_messages].push("Could not add the location #{loc.name}: #{booking.errors.full_messages.join(", ")}")
          end
        end
      end    
    end
    
    if params[:remove_staff]
      params[:remove_staff].each_key do |staff_id|
        if params[:remove_staff][staff_id]
          @event.staff.delete Person.find(staff_id.to_i)
        end
      end
    end
    
    if not params[:add_staff].blank?
      person_id = params[:add_staff].sub(/^(\D+)/, "")
      staffer = Person.find(person_id)
      if staffer
        a = @event.attendances.find_by_person_id(staffer.id)
        a ||= @event.attendances.new :person => staffer, :counts => false
        a.is_staff = true
        if not a.save
          flash[:error_messages].push("Could not add the staff member specified: #{a.errors.full_messages.join(", ")}")
        end
      else
        flash[:error_messages].push("Could not add the staff member specified: person ID \"#{person_id}\" could not be found")
      end
    end

    if @event.kind_of? ProposedEvent
      if not @event.staff.include? @event.proposer
        a = Attendance.new :person => @event.proposer, :event => @event, :is_staff => true, :counts => false
        if not a.save
          flash[:error_messages].push("Could not add the event proposer as a staff member: #{a.errors.full_messages.join(", ")}")
        end
      end
    end
    
    if not params[:add_public_info_field].blank?
      pif = @event.public_info_fields.new :name => params[:add_public_info_field]
      if not pif.save
        flash[:error_messages].push("Couldn't create new PublicInfoField: #{pif.errors.full_messages.join(", ")}")
      end
    end
    
    if params[:delete_public_info_field]
      params[:delete_public_info_field].each_key do |pif_id|
        if params[:delete_public_info_field][pif_id]
          @event.public_info_fields.find(pif_id.to_i).destroy
        end
      end
    end
    
    if params[:add_virtual_site] and not params[:add_virtual_site][:domain].blank?
      site_template_id = params[:add_virtual_site][:site_template]
      if site_template_id and site_template_id != ''
        site_template = SiteTemplate.find(site_template_id)
      end
      vs = @event.virtual_sites.new :domain => params[:add_virtual_site][:domain], :site_template => site_template
      if not vs.save
        flash[:error_messages].push("Couldn't create new VirtualSite: #{vs.errors.full_messages.join(", ")}")
      end
    end
    
    if params[:delete_virtual_site]
      params[:delete_virtual_site].each_key do |vs_id|
        if params[:delete_virtual_site][vs_id]
          @event.virtual_sites.find(vs_id.to_i).destroy
        end
      end
    end
    
    if params[:limited_capacity]
      if (params[:limited_capacity] == "true" and not (@event.kind_of? LimitedCapacityEvent))
        @event.type = "LimitedCapacityEvent"
        @event.save
        @event = Event.find(@event.id)
      elsif (params[:limited_capacity] == "false" and (@event.kind_of? LimitedCapacityEvent))
        @event.type = "Event"
        @event.save
        @event = Event.find(@event.id)
      end
    end
    
    if @event.kind_of? LimitedCapacityEvent and params[:limits]
      %w(male female neutral).each do |gender|
        slot = @event.attendee_slots.find_or_initialize_by_gender(gender)
        slot.update_attributes(params[:limits][gender])
        if not slot.save
          flash[:error_messages].push("Could not change #{gender} attendee limits: #{slot.errors.full_messages.join(", ")}")
        end
      end
    end

    if params[:proposed_event_id]
      @proposed_event = ProposedEvent.find(params[:proposed_event_id])

      ([@proposed_event.proposer] + @proposed_event.staff).uniq.each do |staffer|
        a = Attendance.new :person => staffer, :event => @event, :is_staff => true, :counts => false
        if not a.save
          flash[:error_messages].push("Could not add the staff member specified: #{a.errors.full_messages.join(", ")}")
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
  
  def calculate_edit_vars
    @limited_capacity = @event.kind_of? LimitedCapacityEvent
    @limits = {}
    %w(male female neutral).each do |gender|
      @limits[gender] = {}
      slot = nil
      if @limited_capacity
        slot = @event.attendee_slots.find_by_gender(gender)
      end
      %w(min preferred max).each do |threshold|
        if slot.nil?
          limit = 0
        else
          limit = slot.send(threshold)
        end
        @limits[gender][threshold] = limit
      end
    end
    
    @registration_open = @event.registration_open
    @non_exclusive = @event.non_exclusive
    @age_restricted = @event.age_restricted
    @min_age = @event.min_age
  end
  
  def visible_events
    if @context
      return @context.children
    else
      return Event.find(:all)
    end
  end
end
