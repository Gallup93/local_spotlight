class Artist < ApplicationRecord
  validates_presence_of :zipcode,
                        :city,
                        :state,
                        :spotify_id,
                        :name,
                        :followers

  has_many :user_artists
  has_many :users, through: :user_artists
end
