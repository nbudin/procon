class SiteTemplatesController < ApplicationController
  layout "global"
  rest_edit_permissions
  
  # GET /site_templates
  # GET /site_templates.xml
  def index
    @site_templates = SiteTemplate.find(:all)

    respond_to do |format|
      format.html # index.rhtml
      format.xml  { render :xml => @site_templates.to_xml }
    end
  end

  # GET /site_templates/1
  # GET /site_templates/1.xml
  def show
    @the_template = SiteTemplate.find(params[:id])

    respond_to do |format|
      format.html # show.rhtml
      format.xml  { render :xml => @the_template.to_xml }
    end
  end

  # GET /site_templates/new
  def new
    @the_template = SiteTemplate.new
  end

  # GET /site_templates/1;edit
  def edit
    @the_template = SiteTemplate.find(params[:id])
  end

  # POST /site_templates
  # POST /site_templates.xml
  def create
    @the_template = SiteTemplate.new(params[:the_template])

    respond_to do |format|
      if @the_template.save
        flash[:notice] = 'SiteTemplate was successfully created.'
        format.html { redirect_to site_template_url(@the_template) }
        format.xml  { head :created, :location => edit_site_template_url(@the_template) }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @the_template.errors.to_xml }
      end
    end
  end

  # PUT /site_templates/1
  # PUT /site_templates/1.xml
  def update
    @the_template = SiteTemplate.find(params[:id])

    respond_to do |format|
      if @the_template.update_attributes(params[:the_template])
        flash[:notice] = 'SiteTemplate was successfully updated.'
        format.html { redirect_to edit_site_template_url(@the_template) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @the_template.errors.to_xml }
      end
    end
  end

  # DELETE /site_templates/1
  # DELETE /site_templates/1.xml
  def destroy
    @the_template = SiteTemplate.find(params[:id])
    @the_template.destroy

    respond_to do |format|
      format.html { redirect_to site_templates_url }
      format.xml  { head :ok }
    end
  end
  
  def themeroller
    @the_template = SiteTemplate.find(params[:id])
    
    respond_to do |format|
      format.css { render :text => @the_template.themeroller_css }
    end
  end
end
