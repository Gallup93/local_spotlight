class ArtistsController < ApplicationController

  # def show
  #   @artist = Artist.find(params[:id])
  #   binding.pry
  # end 

  def new
  end

  def create
    artist = Artist.create(artist_params)   
    artist.update(genre: genre_params)

    redirect_to artist_path(artist.id)
  end

  def index
    @artists = current_user.find_closest_artists
  end

  def show
    @artist = Artist.find(params[:id])
    conn = Faraday.new(url: "https://api.spotify.com") do |faraday|
      faraday.headers["Authorization"] = "Bearer #{current_user.token}"
    end
    response = conn.get("/v1/artists/#{@artist.spotify_id}/albums")
    
    @artist_albums = JSON.parse(response.body, symbolize_names: true)
   
  end

  private
  def artist_params
    params.permit(:name, :spotify_id, :zipcode, :description)
  end

  def genre_params
    acc = params.permit(:rock, :pop, :jazz, :country)
    acc.keys 
  end
end


