class Api::V1::UsersController < ApplicationController
  def create

    body = {
      grant_type: "authorization_code",
      code: params[:code],
      redirect_uri: 'http://localhost:3000/api/v1/user',
      client_id: ENV['SPOTIFY_CLIENT_ID'],
      client_secret: ENV['SPOTIFY_CLIENT_SECRET']
    }

    auth_response = Faraday.post('https://accounts.spotify.com/api/token', body)
    auth_params = JSON.parse(auth_response.body)
    header = {
      Authorization: "Bearer #{auth_params["access_token"]}"
    }
    user_response = Faraday.get("https://api.spotify.com/v1/me", nil, header)
    user_params = JSON.parse(user_response.body)

    @user = return_user_by_username(user_params["display_name"])

    if @user == nil
      @user = User.create(
        username: user_params["display_name"],
        href: user_params["external_urls"]["spotify"],
        email: user_params["email"],
        token: auth_params["access_token"],
        refresh_token: auth_params["refresh_token"]
      )
      redirect_to "/api/v1/preferences"
    else
      @user.update_attributes(token: auth_params["access_token"], refresh_token: auth_params["refresh_token"])
      redirect_to '/api/v1/dashboard'
    end
    session[:user_id] = @user.id
    session[:temp_zip] = @user.zipcode
  end

  def show
    @favorites = UserArtist.all.where(user_id: current_user.id)
  end

  def update
    if params["zipcode"]
      current_user.update_attribute(:zipcode, params["zipcode"])
      session[:temp_zip] = current_user.zipcode
      redirect_to "/api/v1/dashboard"
    end
  end
end
