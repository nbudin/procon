class VirtualSitesController < ApplicationController
  load_and_authorize_resource
  
  def index
  end
  
  def show
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @virtual_site.to_xml }
    end
  end
  
  def update
    respond_to do |format|
      if @virtual_site.update_attributes(params[:virtual_site])
        format.html { redirect_to virtual_sites_url }
        format.xml  { head :ok }
      else
        format.html { render :action => "show" }
        format.xml  { render :xml => @virtual_site.errors.to_xml }
      end
    end
  end
  
  def create
    respond_to do |format|
      if @virtual_site.save
        format.html { redirect_to virtual_sites_url }
        format.xml  { head :created, :location => virtual_site_url(@virtual_site) }
      else
        format.html { render :action => "index" }
        format.xml  { render :xml => @virtual_site.errors.to_xml }
      end
    end
  end
  
  def destroy
    @virtual_site.destroy
    
    redirect_to virtual_sites_url
  end
end
