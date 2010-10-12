class AttendancesController < ApplicationController
  before_filter :load_event
  load_and_authorize_resource
  
  def email_list    
    scope = if params[:waitlist]
      @event.attendances.waitlist
    else
      @event.attendances.confirmed
    end
    @attendees = scope.includes(:person).all.map(&:person)
  end
  
  def signup_sheet_form
  end
  
  def signup_sheet
    @options = {}
    @options[:include_scheduling_details] = params[:include_scheduling_details]
    @options[:include_blurb] = params[:include_blurb]
    @options[:include_stafflist] = params[:include_stafflist]
    @options[:empty_slot_min] = params[:empty_slot_min].to_i
    @include_children = params[:include_children]
    @exclude_event = params[:exclude_event]

	  render :layout => "signup_sheet"
  end
  
  # GET /attendances
  # GET /attendances.xml
  def index    
    @confirmed_attendances = @event.attendances.confirmed.for_agenda.all
    @waitlist_attendances = @event.attendances.waitlist.for_agenda.all
    @deleted_attendances = Attendance.dropped_from(@event).includes(:person).all

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => (@confirmed_attendances + @waitlist_attendances + @deleted_attendances).to_xml }
      format.rss do
        @attendances = (@confirmed_attendances + @waitlist_attendances).sort_by { |att| att.created_at }.reverse.slice(0..9)
        render :layout => false
      end
    end
  end

  def children
    @children = @context.children.reject { |e| e.kind_of? ProposedEvent }
    @attendances = @children.collect { |e| e.attendances.for_agenda.all + Attendance.dropped_from(e).includes(:person).all }.flatten
    @attendances.reject! { |a| a.person.nil? }
    @attendances = @attendances.sort_by { |a| a.created_at }.reverse

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @attendances.to_xml }
      format.rss do
        @attendances = @attendances.slice(0..9)
        render :action => :index, :layout => false
      end
    end
  end

  # GET /attendances/1
  # GET /attendances/1.xml
  def show
    @attendance = Attendance.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @attendance.to_xml }
    end
  end

  # GET /attendances/new
  def new
    @attendance = Attendance.new
  end

  # GET /attendances/1;edit
  def edit
    @attendance = Attendance.find(params[:id])
  end

  # POST /attendances
  # POST /attendances.xml
  def create
    @attendance = Attendance.new(params[:attendance])
    @attendance.event = @event

    respond_to do |format|
      if @attendance.save
        flash[:notice] = 'Attendance was successfully created.'
        format.html { redirect_to event_attendances_url(@event) }
        format.xml  { head :created, :location => event_attendance_url(@event, @attendance) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @attendance.errors.to_xml }
      end
    end
  end

  # PUT /attendances/1
  # PUT /attendances/1.xml
  def update
    @attendance = Attendance.find(params[:id])
  
    respond_to do |format|
      if @attendance.update_attributes(params[:attendance])
        flash[:notice] = 'Attendance was successfully updated.'
        format.html { redirect_to event_attendances_url(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @attendance.errors.to_xml }
      end
    end
  end

  # DELETE /attendances/1
  # DELETE /attendances/1.xml
  def destroy
    @attendance = Attendance.find(params[:id])
    @attendance.deleted_at ||= Time.now
    @attendance.save!

    respond_to do |format|
      format.html { redirect_to event_attendances_url(@event) }
      format.xml  { head :ok }
    end
  end
  
  private
  def load_event
    @event = Event.includes(:staffers => :person).find(params[:event_id])
  end
end
