class ApplicationController < ActionController::Base
  helper_method :current_user
  helper_method :find_artist_by_id
  helper_method :artists_nearby
  helper_method :favorite_text

  def artists_nearby(zipcodes)
    z = zipcodes.env.response_body
    z = z.scan(/...../)
    acc = []
    z.each do |zip|
      acc << Artist.where(zipcode: zip)
    end
    acc2 = acc.flatten
    acc2
  end

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def return_user_by_username(username)
    User.find_by(username: username)
  end

  def find_artist_by_id(id)
    Artist.find(id)
  end

  def find_artist_by_spotify_id(spotify_id)
    Artist.find_by spotify_id: spotify_id
  end

  def select_genres(genres)
    if !genres.nil?
      house_genres = ["pop", "rock", "country", "jazz", "hip hop", "rap", "R&B", "punk", "electronic", "psychedelic", "indie"]
      matching_genres = []
      genres.each do |genre|
        house_genres.each do |h_genre|
          if genre.include?(h_genre)
            matching_genres << h_genre
          end
        end
      end
      matching_genres.uniq
    else
      "No listed genres"
    end
  end

  def favorite_text
    return @favorite_exists ? "Unfavorite" : "Favorite"
  end
end
