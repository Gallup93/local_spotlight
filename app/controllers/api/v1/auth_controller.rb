class Api::V1::AuthController < ApplicationController

  def spotify_request
    url = "https://accounts.spotify.com/authorize"
    query_params = {
      client_id: ENV['SPOTIFY_CLIENT_ID'],
      response_type: 'code',
      redirect_uri: "http://localhost:3000/api/v1/user",
      scope: "user-library-read
      playlist-read-collaborative
      playlist-modify-private
      user-modify-playback-state
      user-read-email
      user-follow-modify",
      show_dialog: true
    }
    redirect_to "#{url}?#{query_params.to_query}"
  end
end