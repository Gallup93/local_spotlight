class SpotifyService

    def albums(artist, token)
      conn = Faraday.new(url: "https://api.spotify.com") do |faraday|
        faraday.headers["Authorization"] = "Bearer #{token}"
      end
      response = conn.get("/v1/artists/#{artist.spotify_id}/albums")
      artist_albums = JSON.parse(response.body, symbolize_names: true)
  end
   
end 