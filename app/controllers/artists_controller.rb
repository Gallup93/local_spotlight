class ArtistsController < ApplicationController

  def new
  end

  def create
    artist = Artist.create(artist_params)
    artist.update(genre: genre_params)

    redirect_to artist_path(artist.id)
  end

  def index
    
    zipcodes = current_user.find_zipcodes_and_radius(session[:temp_zip], session[:radius])
    
    @artists = artists_nearby(zipcodes)
  end

  def show
    @artist = Artist.find(params[:id])
    results = AlbumSearch.new
    @albums = results.albums(@artist, current_user.token)
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
