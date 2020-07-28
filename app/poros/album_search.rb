class AlbumSearch 
  
  def albums(artist, token) 
    artist_albums = SpotifyService.new.albums(artist, token)
    albums = artist_albums[:items].map do |album_info|
      Album.new(album_info)
    end 
  end
  
end 