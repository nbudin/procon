class AttendancesController < ApplicationController
  layout "global"
  
  before_filter :check_view_permissions, :only => [ :index, :show ]
  before_filter :check_edit_permissions, :only => [ :new, :edit, :create, :update, :destroy ]
  
  # GET /attendances
  # GET /attendances.xml
  def index
    @event = Event.find(params[:event_id])
    @attendances = @event.attendances

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @attendances.to_xml }
    end
  end

  # GET /attendances/1
  # GET /attendances/1.xml
  def show
    @event = Event.find(params[:event_id])
    @attendance = Attendance.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @attendance.to_xml }
    end
  end

  # GET /attendances/new
  def new
    @event = Event.find(params[:event_id])
    @attendance = Attendance.new
  end

  # GET /attendances/1;edit
  def edit
    @event = Event.find(params[:event_id])
    @attendance = Attendance.find(params[:id])
  end

  # POST /attendances
  # POST /attendances.xml
  def create
    params[:attendance][:person] = Person.find params[:attendance][:person]
    @event = Event.find(params[:event_id])
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
    @event = Event.find(params[:event_id])
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
    @event = Event.find(params[:event_id])
    @attendance = Attendance.find(params[:id])
    @attendance.destroy

    respond_to do |format|
      format.html { redirect_to event_attendances_url(@event) }
      format.xml  { head :ok }
    end
  end
  
  def check_view_permissions
    event = Event.find params[:event_id]
    if logged_in? and event.attendees_visible_to?(logged_in_person)
      return
    end
    flash[:error_messages] = ["You aren't permitted to perform that action.  Please log into an account that has permissions to do that."]
    redirect_to events_url
  end
  
  def check_edit_permissions
    event = Event.find params[:event_id]
    if logged_in? and event.has_edit_permissions?(logged_in_person)
      return
    end
    flash[:error_messages] = ["You aren't permitted to perform that action.  Please log into an account that has permissions to do that."]
    redirect_to events_url
  end
end
