class User < ApplicationRecord
  has_many :user_artists
  has_many :artists, through: :user_artists

  def find_closest_artists
    @artists = Artist.all 
    # MapService.new(current_user.zipcode)
  end

end
