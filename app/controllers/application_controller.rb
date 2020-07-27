class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :find_artist_by_id


  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def temp_zip
    session[:temp_zip]
  end

  def return_user_by_username(username)
    User.find_by(username: username)
  end

  def find_artist_by_id(id)
    Artist.find(id)
  end
end
