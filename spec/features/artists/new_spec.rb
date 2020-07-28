require 'rails_helper'

RSpec.describe "As a user" do
  describe "when I visit the new artist page" do
    it "has a form that allows me to input a new local artist" do
      user = create(:user)

      user.update_attribute(:token, ENV['SPOTIFY_TEMP_TOKEN'])
      user.update_attribute(:zipcode, 61109)

      artist_json = File.read("spec/fixtures/spotify/single_artist_61109.json")
      album_json = File.read("spec/fixtures/artist_albums.json")

      stub_request(:get, "https://api.spotify.com/v1/artists/77WeI8znTJNL9VgXxJVfOO/albums").
        with(
          headers: {
         'Accept'=>'*/*',
         'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
         'Authorization'=>"Bearer #{ENV['SPOTIFY_TEMP_TOKEN']}",
         'User-Agent'=>'Faraday v1.0.1'
          }).
        to_return(status: 200, body: album_json, headers: {})

      stub_request(:get, "https://api.spotify.com/v1/artists/77WeI8znTJNL9VgXxJVfOO").
         with(
           headers: {
       	  'Accept'=>'*/*',
       	  'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
       	  'Authorization'=>'Bearer',
       	  'User-Agent'=>'Faraday v1.0.1'
           }).
         to_return(status: 200, body: artist_json, headers: {})



      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
      allow_any_instance_of(ApplicationController).to receive(:temp_zip).and_return(61109)

      visit '/artists/new'

      fill_in :spotify_id, with: "77WeI8znTJNL9VgXxJVfOO"
      fill_in :description, with: "Momma's Alright. Daddy's Alright. They just seem a little weird"
      fill_in :zipcode, with: 61109

      click_on "Add Artist"

      expect(current_path).to eq("/artists/#{Artist.last.id}")

      within ".artist-name" do
        expect(page).to have_content("Cheap Trick")
      end
      within ".description" do
        expect(page).to have_content("Momma's Alright. Daddy's Alright. They just seem a little weird")
      end
    end
  end
end
