class ApplicationController < ActionController::Base
  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def return_user_by_username(username)
    User.find_by(username: username)
  end
end
