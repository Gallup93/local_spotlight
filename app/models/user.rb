class User < ApplicationRecord
  has_many :user_artists
  has_many :artists, through: :user_artists

  def find_closest_artists
    # @artists = Artist.all
    # MapService.new(current_user.zipcode)
  end

  def favorited?(user_id, artist_id)
    User.find(user_id).artists.any? { |artist| artist.id == artist_id}
  end
end
