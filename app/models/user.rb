class User < ApplicationRecord
  has_many :user_artists
  has_many :artists, through: :user_artists

  def find_zipcodes(zip)
    conn = Faraday.new("http://localhost:4567")
    response = conn.get("/zipradius?radius=15&zip=#{zip}")
  
  end

  def favorited?(user_id, artist_id)
    User.find(user_id).artists.any? { |artist| artist.id == artist_id}
  end
end
