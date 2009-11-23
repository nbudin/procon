class AttendancesController < ApplicationController
  layout "global"
  
  before_filter :get_event
  
  access_control :subject_method => :procon_profile do
    allow :superadmin
    allow :staff, :of => :event
    allow :attendee, :of => :event, :to => [ :index, :show ], :if => :event_attendees_visible?
  end
  
  # GET /attendances
  # GET /attendances.xml
  def index
    @attendances = @event.attendances

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @attendances.to_xml }
      format.rss do
        @attendances = @event.attendances.find(:all, :order => "created_at DESC", :limit => 10)
        render :layout => false
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
    person_id = params[:attendance][:person].sub(/^\D+/, "")
    params[:attendance][:person] = Person.find(person_id)
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
    @attendance.destroy

    respond_to do |format|
      format.html { redirect_to event_attendances_url(@event) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def get_event
    @event ||= params[:event_id] && Event.find(params[:event_id])
  end
  
  def event_attendees_visible?
    @event.attendees_visible
  end
end
