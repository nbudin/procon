# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  layout "global"
  before_filter :get_virtual_site
  helper 'illyan'
  
  access_control :helper => :can_edit_event? do
    allow :superadmin
    allow :effective_staff, :of => :event
  end
  
  alias_method :can_edit_events?, :can_edit_event?  
  helper_method :can_edit_event?
  helper_method :can_edit_events?
  
  access_control :helper => :can_view_attendees? do
    allow :superadmin
    allow :effective_staff, :of => :event
  end
  
  access_control :helper => :superadmin? do
    allow :superadmin
  end
  helper_method :superadmin?
  
  def procon_profile
    @procon_profile ||= logged_in_person && logged_in_person.app_profile
  end
  helper_method :procon_profile

  private
  
  def get_virtual_site
    @virtual_site = VirtualSite.find_by_domain request.host
    if @virtual_site.nil?
      @virtual_site = VirtualSite.new
    end
    if @virtual_site.site_template.nil?
      @virtual_site.build_site_template
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
