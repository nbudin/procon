class LocationsController < ApplicationController
  load_and_authorize_resource
  
  # GET /locations
  # GET /locations.xml
  def index
    @locs = visible_locations

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @locs }
    end
  end

  # GET /locations/1
  # GET /locations/1.xml
  def show
    @loc = Location.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @loc }
    end
  end

  # GET /locations/new
  # GET /locations/new.xml
  def new
    @loc = Location.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @loc }
    end
  end

  # GET /locations/1/edit
  def edit
    @loc = Location.find(params[:id])
  end

  # POST /locations
  # POST /locations.xml
  def create
    @loc = Location.new(params[:location])

    respond_to do |format|
      if @loc.save
        format.js do
          render :update do |page|
            addid = "add_location_" + (@loc.parent ? @loc.parent.id.to_s : "root")
            page.insert_html(:before, addid, :partial => "location", :locals => { :loc => @loc })
            page << "makeCollapsibleById('child_locations_#{@loc.id}');"
            page << "jQuery('\##{addid}').val('');"
          end
        end
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @loc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /locations/1
  # PUT /locations/1.xml
  def update
    @loc = Location.find(params[:id])

    respond_to do |format|
      if @loc.update_attributes(params[:location])
        flash[:notice] = 'Location was successfully updated.'
        format.html { redirect_to(@loc) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @loc.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /locations/1
  # DELETE /locations/1.xml
  def destroy
    @loc = Location.find(params[:id])
    @loc.destroy

    respond_to do |format|
      format.html { redirect_to(locations_url) }
      format.js {
        render :update do |page|
          page.remove("location_#{params[:id]}")
        end
      }
      format.xml  { head :ok }
    end
  end
  
  private
  def visible_locations
    if @context
      return @context.locations
    else
      return Location.find(:all)
    end
  end
end
