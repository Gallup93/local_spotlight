class SessionsController < ApplicationController

 def destroy
    reset_session
    flash[:notice] = "You have been logged out"
    redirect_to '/'
  end 
end