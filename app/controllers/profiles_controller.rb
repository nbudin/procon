class ProfilesController < ApplicationController
  skip_authorization_check
  before_filter :authenticate_person!
  
  def show
  end
  
  def update
    if current_person.update_attributes(params[:person].slice(:nickname, :gender, :phone, :best_call_time))
      flash[:notice] = "Your changes have been saved."
      return_url = session[:return_to_after_profile_complete] || profile.path
      session[:return_to_after_profile_complete] = nil
      redirect_to return_url
    else
      render :action => "show"
    end
  end
  
  private
  def devise_or_profile_controller?
    true
  end
end
