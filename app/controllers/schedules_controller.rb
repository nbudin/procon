class SchedulesController < ApplicationController
  before_filter :check_edit_permissions, :except => [:index, :show]
  before_filter :check_published, :only => [:show]
  
  # GET /schedules
  # GET /schedules.xml
  def index
    show_unpublished = (logged_in? and logged_in_person.procon_profile.has_edit_permissions?(@context))
    if @context
      if show_unpublished
        @schedules = @context.schedules
      else
        @schedules = @context.schedules.find_all_by_published(true)
      end
      @schedule = Schedule.new :event => @context
    else
      if show_unpublished
        @schedules = Schedule.find(:all)
      else
        @schedules = Schedule.find_all_by_published(true)
      end
      @schedule = Schedule.new
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @schedules }
    end
  end

  # GET /schedules/1
  # GET /schedules/1.xml
  def show
    @interval = params[:interval] ? params[:interval].to_i : 30.minutes
    @schedule = Schedule.find(params[:id])
    @events = @schedule.events
    @blocks = @schedule.obtain_blocks
    @blocks.sort! { |a, b| a.start <=> b.start }
    
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/new
  # GET /schedules/new.xml
  def new
    @schedule = Schedule.new

    respond_to do |format|
      format.xml  { render :xml => @schedule }
    end
  end

  # GET /schedules/1/edit
  def edit
    @schedule = Schedule.find(params[:id])
  end

  # POST /schedules
  # POST /schedules.xml
  def create
    @schedule = Schedule.new(params[:schedule])

    respond_to do |format|
      if @schedule.save
        flash[:notice] = 'Schedule was successfully created.'
        format.html { redirect_to(@schedule) }
        format.xml  { render :xml => @schedule, :status => :created, :location => @schedule }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /schedules/1
  # PUT /schedules/1.xml
  def update
    @schedule = Schedule.find(params[:id])
    
    if params[:event]
      params[:event].each_pair do |event_id, args|
        event = Event.find(event_id)
        event.update_attributes(args)
        event.save
      end
    end
    
    if params[:remove_event_from_track]
      params[:remove_event_from_track].each_pair do |track_id, events|
        track = Track.find(track_id)
        events.each do |event_id|
          event = Event.find(event_id)
          track.events.delete(event)
        end
      end
    end
    
    if params[:add_event_to_track]
      params[:add_event_to_track].each_pair do |track_id, event_id|
        if event_id and event_id != ''
          track = Track.find(track_id)
          track.events.push(Event.find(event_id))
        end
      end
    end
    
    if params[:create_event_in_track]
      params[:create_event_in_track].each_pair do |track_id, args|
        if args[:fullname] and args[:fullname] != ''
          track = Track.find(track_id)
          event = track.events.create(args.update({:parent => @schedule.event}))
          event.set_default_registration_policy
        end
      end
    end
    
    if params[:track_color]
      params[:track_color].each_pair do |track_id, color|
        track = Track.find(track_id)
        track.color = color
        track.save
      end
    end
    
    if params[:delete_track]
      params[:delete_track].each do |track_id|
        Track.destroy(track_id)
      end
    end
    

    
    if params[:new_track]
      if params[:new_track][:name] and params[:new_track][:name] != ''
        @schedule.tracks.create(params[:new_track])
      end
    end

    respond_to do |format|
      if @schedule.update_attributes(params[:schedule])
        flash[:notice] = 'Schedule was successfully updated.'
        format.html { redirect_to(edit_schedule_path(@schedule)) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @schedule.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /schedules/1
  # DELETE /schedules/1.xml
  def destroy
    @schedule = Schedule.find(params[:id])
    @schedule.destroy

    respond_to do |format|
      format.html { redirect_to(schedules_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  def check_edit_permissions
    if logged_in? and logged_in_person.procon_profile.has_edit_permissions?(@context)
      return
    end
    flash[:error_messages] = ["You aren't permitted to perform that action.  Please log into an account that has permissions to do that."]
    redirect_to schedules_url
  end
  
  def check_published
    if logged_in? and logged_in_person.procon_profile.has_edit_permissions?(@context)
      return
    end
    @schedule = Schedule.find(params[:id])
    if @schedule and @schedule.published
      return
    end
    flash[:error_messages] = ["That schedule has not yet been published."]
    redirect_to schedules_url
  end
end
