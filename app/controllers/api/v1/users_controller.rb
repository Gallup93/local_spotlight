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

    @user = User.find_or_create_by(
      username: user_params["display_name"],
      href: user_params["external_urls"]["spotify"],
      email: user_params["email"]
    )

    session[:user_id] = @user.id
    # The code below will need to be completed to address the access token expiring after 1 hour
    # if @user.access_token_expired?
    #   @user.refresh_access_token
    # else
    #   @user.update(
    #     access_token: auth_params["access_token"],
    #     refresh_token: auth_params["refresh_token"]
    #   )
    # end
  end

  def show
    @favorites = UserArtist.all.where(user_id: current_user.id)
  end
end
