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









  # describe "when I visit the new artist page" do
  #
  #   it "has a form that allows me to input a new local artist" do
  #     user = create(:user)
  #
  #     user.update_attribute(:token, ENV['SPOTIFY_TEMP_TOKEN'])
  #     user.update_attribute(:zipcode, 61109)
  #
  #     artist_json = File.read("spec/fixtures/spotify/single_artist_61109.json")
  #     album_json = File.read("spec/fixtures/artist_albums.json")
  #
  #     stub_request(:get, "https://api.spotify.com/v1/artists/77WeI8znTJNL9VgXxJVfOO/albums").
  #       with(
  #         headers: {
  #        'Accept'=>'*/*',
  #        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  #        'Authorization'=>"Bearer #{ENV['SPOTIFY_TEMP_TOKEN']}",
  #        'User-Agent'=>'Faraday v1.0.1'
  #         }).
  #       to_return(status: 200, body: album_json, headers: {})
  #
  #     stub_request(:get, "https://api.spotify.com/v1/artists/77WeI8znTJNL9VgXxJVfOO").
  #        with(
  #          headers: {
  #      	  'Accept'=>'*/*',
  #      	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
  #      	  'Authorization'=>'Bearer',
  #      	  'User-Agent'=>'Faraday v1.0.1'
  #          }).
  #        to_return(status: 200, body: artist_json, headers: {})
  #
  #
  #
  #     allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
  #     allow_any_instance_of(ApplicationController).to receive(:temp_zip).and_return(61109)
  #
  #     visit '/artists/new'
  #
  #
  #
  #     click_on "Add Artist"
