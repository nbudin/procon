class MainController < ApplicationController
  def index
    if @context
      redirect_to event_url(@context)
    elsif logged_in?
      redirect_to :controller => :agenda, :site_template => @site_template.id
    end
  end
end
