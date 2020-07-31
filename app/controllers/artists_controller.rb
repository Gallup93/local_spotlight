class ArtistsController < ApplicationController

  def new
  end

  def create
    if !find_artist_by_spotify_id(params[:spotify_id]).nil?
      existing_artist
    else
      json_parsed = get_service
      matching_genres = select_genres(json_parsed["genres"])
      zip_info = ZipCodes.identify(params[:zipcode])
      if zip_info.nil?
        zip_error
      else
        artist = Artist.new(name: json_parsed["name"],
                        followers: json_parsed["followers"]["total"],
                        genre: matching_genres,
                        images: json_parsed["images"],
                        popularity: json_parsed["popularity"],
                        spotify_id: params[:spotify_id],
                        zipcode: params[:zipcode],
                        description: params[:description],
                        city: zip_info[:city],
                        state: zip_info[:state_name])
        if !find_artist_by_spotify_id(params[:spotify_id]) && artist.save
          redirect_to artist_path(artist.id)
        end
      end
    end
  end

  def index
    zipcodes = current_user.find_zipcodes_and_radius(session[:temp_zip], session[:radius])
    artists = artists_nearby(zipcodes)
    if !artists.empty?
      @artists = artists
    else
      @artists = Artist.all
    end
    if params[:new_artist]
      @favorite_exists = !UserArtist.where(user_id: current_user.id, artist_id: params[:new_artist]).empty?
    else
      @favorite_exists = !UserArtist.where(user_id: current_user.id, artist_id: @artists[0].id).empty?
    end
  end

  def show
    @artist = Artist.find(params[:id])
    results = AlbumSearch.new
    @albums = results.albums(@artist, current_user.token)
  end

  private

  def existing_artist
    flash[:error] = "This Artist already exists in the database."
    redirect_to new_artist_path
  end

  def get_service
    service = GetSpotifyArtist.new
    json = service.find_artist(params[:spotify_id], current_user.token)
    JSON.parse(json.body, symbolize: true)
  end

  def zip_error
    flash[:error] = "Zipcode does not exist."
    redirect_to new_artist_path
  end
end
