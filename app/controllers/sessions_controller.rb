class SessionsController < ApplicationController
  def destroy
    reset_session
    flash[:notice] = "You have been logged out"
    redirect_to '/'
  end

  def update
    session[:temp_zip] = params["zipcode"]
    redirect_to request.referrer
  end
end
