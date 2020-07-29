class SessionsController < ApplicationController
  def destroy
    reset_session
    flash[:notice] = "You have been logged out"

    redirect_to '/'
  end

  def update
    if params[:zipcode]
      session[:temp_zip] = params["zipcode"]
    end
    if params[:radius]
      session[:radius] = params[:radius]
    end
    redirect_to request.referrer
  end
end
