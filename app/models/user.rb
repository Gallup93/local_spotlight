class User < ApplicationRecord
  has_many :user_artists
  has_many :artists, through: :user_artists

  def find_zipcodes_and_radius(zip, radius)
    radius = radius.delete(" Miles")
    conn = Faraday.new("https://frozen-sierra-74026.herokuapp.com")
    response = conn.get("/zipradius?radius=#{params[:radius]}&zip=#{zip}")
  end

  def favorited?(user_id, artist_id)
    User.find(user_id).artists.any? { |artist| artist.id == artist_id}
  end
end
