class ApplicationController < ActionController::Base
  protect_from_forgery
  layout "global"
  before_filter :get_virtual_site
  
  def current_ability
    @current_ability ||= Ability.new(current_person)
  end
  
  def context
    @context ||= (params[:id] && Event.find(params[:id]))
  end
  
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
    people.sort_by {|p| "#{p.lastname}#{p.firstname}".downcase}
  end
end
