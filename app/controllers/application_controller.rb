# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_procon_session_id'
  layout "global"
  before_filter :get_virtual_site
  
  private
  
  def get_virtual_site
    @virtual_site = VirtualSite.find_by_domain request.host
    if @virtual_site.nil?
      @virtual_site = VirtualSite.new
    end
    if @virtual_site.site_template.nil?
      @virtual_site.site_template = SiteTemplate.new
    end
    @hide_chrome = false
    if params[:site_template]
      if params[:site_template] == 'none'
        @site_template = SiteTemplate.new
        @hide_chrome = true
      else
        @site_template = SiteTemplate.find params[:site_template]
      end
    else
      @site_template = @virtual_site.site_template
    end
    @context = @virtual_site.event
  end
  
  def sort_people(people)
    people.sort {|a, b| "#{a.lastname}#{a.firstname}".downcase <=> "#{b.lastname}#{b.firstname}".downcase}
  end
end
