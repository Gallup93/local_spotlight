class ArtistsController < ApplicationController

  def new
  end

  def create
    service = GetSpotifyArtist.new
    json = service.find_artist(params[:spotify_id], current_user.token)
    json_parsed = JSON.parse(json.body, symbolize: true)
    matching_genres = select_genres(json_parsed["genres"])

    zip_info = ZipCodes.identify(params[:zipcode])

    artist = Artist.new(name: json_parsed["name"], followers: json_parsed["followers"]["total"],
      genre: matching_genres, images: json_parsed["images"], popularity: json_parsed["popularity"],
      spotify_id: params[:spotify_id], zipcode: params[:zipcode], description: params[:description],
      city: zip_info[:city], state: zip_info[:state_name])

    if !find_artist_by_spotify_id(params[:spotify_id]) && artist.save
      redirect_to artist_path(artist.id)
    else
      flash[:error] = artist.errors.full_messages.to_sentence
      redirect_to "artists/new"
    end
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
    params.permit(:spotify_id, :zipcode, :description)
  end
end
