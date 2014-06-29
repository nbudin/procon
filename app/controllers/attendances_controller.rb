class AttendancesController < ApplicationController
  layout "global"
  
  load_resource :event
  load_and_authorize_resource :through => :event, :except => :children
  
  # GET /attendances
  # GET /attendances.xml
  def index
    @attendances = @event.attendances.all(:include => :person)
    @deleted_attendances = @event.attendances.all(:include => [:event, :person], :only_deleted => true)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @attendances.to_xml }
      format.rss do
        @attendances = @event.attendances.find(:all, :order => "created_at DESC", :limit => 10)
        render :layout => false
      end
    end
  end

  def children
    authorize! :view_children_attendances, @event
    @children = @context.children.reject { |e| e.kind_of? ProposedEvent }
    @attendances = @children.collect { |e| e.attendances.all(:with_deleted => true) }.flatten
    @attendances.reject! { |a| a.person.nil? }
    @attendances = @attendances.sort_by { |a| a.created_at }.reverse

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @attendances.to_xml }
      format.rss do
        @attendances = @attendances.slice(0..10)
        render :layout => false
      end
    end
  end

  # GET /attendances/1
  # GET /attendances/1.xml
  def show
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @attendance.to_xml }
    end
  end

  # GET /attendances/new
  def new
  end

  # GET /attendances/1;edit
  def edit
  end

  # POST /attendances
  # POST /attendances.xml
  def create
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
    @attendance.destroy

    respond_to do |format|
      format.html { redirect_to event_attendances_url(@event) }
      format.xml  { head :ok }
    end
  end
end
