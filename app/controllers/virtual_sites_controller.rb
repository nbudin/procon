class VirtualSitesController < ApplicationController
  access_control do
    allow :superadmin
  end
  
  def index
    @virtual_sites = VirtualSite.all
  end
  
  def show
    @virtual_site = VirtualSite.find(params[:id])
    
    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @virtual_site.to_xml }
    end
  end
  
  def update
    @virtual_site = VirtualSite.find(params[:id])
    
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
    @virtual_site = VirtualSite.new(params[:virtual_site])
    
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
    @virtual_site = VirtualSite.find(params[:id])
    @virtual_site.destroy
    
    redirect_to virtual_sites_url
  end
end
