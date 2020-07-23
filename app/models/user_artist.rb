class UserArtist < ApplicationRecord
  belongs_to :user
  belongs_to :artist

  def get_name_by_id(artist_id)
    Artist.find(artist_id).name
  end
end
