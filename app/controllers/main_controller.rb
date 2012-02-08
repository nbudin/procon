class MainController < ApplicationController
  skip_authorization_check
  
  def index
    if @context
      redirect_to event_url(@context)
    elsif person_signed_in?
      redirect_to :controller => :agenda, :site_template => @site_template.id
    end
  end
end
