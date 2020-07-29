class GetSpotifyArtist
  def find_artist(spotify_id, token)
    conn = Faraday.new(url: "https://api.spotify.com") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{token}"
    end
    response = conn.get("/v1/artists/#{spotify_id}")
  end
end
