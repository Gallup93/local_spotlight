class ArtistsController < ApplicationController
  def new
  end

  def create
    artist = Artist.create!(artist_params)
    artist.update(genre: genre_params)

    redirect_to artist_path(artist.id)
  end

  def index
    @artists = current_user.find_closest_artists
  end

  def show
    @artist = Artist.find(params[:id])
  end

  private
  def artist_params
    params.permit(:name, :spotify_id, :zipcode)
  end

  def genre_params
    acc = params.permit(:rock, :pop, :jazz, :country)
    acc.keys
  end
end