require 'rails_helper'

RSpec.describe UserArtist, type: :model do
  describe "relationships" do
    it {should belong_to :user}
    it {should belong_to :artist}
  end
end
