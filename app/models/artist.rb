class Artist < ApplicationRecord
  validates_presence_of :name,
                        :zipcode,
                        :spotify_id

  has_many :user_artists
  has_many :users, through: :user_artists
end
