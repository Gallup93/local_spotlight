class User < ApplicationRecord
  has_many :user_artists
  has_many :artists, through: :user_artists
end