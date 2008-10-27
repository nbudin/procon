# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_procon_session_id'
  layout "global"
  before_filter :get_virtual_site
  
  def get_virtual_site
    @virtual_site = VirtualSite.find_by_domain request.host
    if @virtual_site.nil?
      @virtual_site = VirtualSite.new
    end
    if @virtual_site.site_template.nil?
      @virtual_site.build_site_template
    end
    if params[:site_template]
      if params[:site_template] == 'none'
        @site_template = SiteTemplate.new
        @site_template.header = " "
        @site_template.footer = " "
      else
        @site_template = SiteTemplate.find params[:site_template]
      end
    else
      @site_template = @virtual_site.site_template
    end
    @context = @virtual_site.event
  end
  
end
