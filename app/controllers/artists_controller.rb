class ArtistsController < ApplicationController


  def new
  end

  def create

    service = GetSpotifyArtist.new
    json = service.find_artist(params[:spotify_id], params[:authenticity_token])
    json_parsed = JSON.parse(json.body, symbolize: true)
    matching_genres = select_genres(json_parsed["genres"])


    zip_info = ZipCodes.identify(params[:zipcode])
    artist = Artist.new(name: json_parsed["name"], followers: json_parsed["followers"]["total"], genre: matching_genres, images: json_parsed["images"], popularity: json_parsed["popularity"], spotify_id: params[:spotify_id], zipcode: params[:zipcode], description: params[:description], city: zip_info[:city], state: zip_info[:state_name])

    if !find_artist_by_spotify_id(params[:spotify_id]) && artist.save
      redirect_to artist_path(artist.id)
    else
      flash[:error] = artist.errors.full_messages.to_sentence
      redirect_to "artists/new"
    end
  end

  def index
    zipcodes = current_user.find_zipcodes(current_user.zipcode)

    @artists = artists_nearby(zipcodes)
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
    params.permit(:spotify_id, :zipcode, :description)
  end

  # def genre_params
  #   acc = params.permit(:rock, :pop, :jazz, :country)
  #   acc.keys
  # end
end
