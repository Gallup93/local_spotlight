require 'rails_helper'

RSpec.describe Artist, type: :model do
  describe "validations" do
    it {should validate_presence_of :name}
    it {should validate_presence_of :zipcode}
   
    it {should validate_presence_of :spotify_id}
  end
  describe "relationships" do
    it {should have_many :user_artists}
    it {should have_many(:users).through(:user_artists)}
  end
end
