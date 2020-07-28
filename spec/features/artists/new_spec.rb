require 'rails_helper'

RSpec.describe "As a user" do
  before(:each) do
    @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210",
                         token: "BQDuD9FNAPMxGmouEEYquJwOeX-mLL6uUs5mIzsxR3g2W_WgXmvctinBV9qTiqHZYaycgOs3kc8gyt-nr2O1_STU3b6GvuhfRPidQAJgmXwLZr9C2UEZQIqhun-hAlnQAS4nW9eqH3R2GglsBXvLeo77k4uB_IQddTOFWDHtXIuWTSbMnlPaWscMBYFbm3ma")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  end
    it "has a form that allows me to input a new local artist", :vcr do

      visit '/api/v1/dashboard'

      click_on "Add New Artist"

      expect(current_path).to eq(new_artist_path)

      fill_in :spotify_id, with: "1LB8qB5BPb3MHQrfkvifXU"
      fill_in :description, with: "Momma's Alright. Daddy's Alright. They just seem a little weird"
      fill_in :zipcode, with: 61109

      click_on("Add Artist")

      artist = Artist.last

      expect(current_path).to eq("/artists/#{artist.id}")

      within ".artist-name" do
        expect(page).to have_content("Cheap Trick")
      end

      within ".description" do
        expect(page).to have_content("Momma's Alright. Daddy's Alright. They just seem a little weird")
      end

      expect(page).to have_css('.player')
    end
  end
