require 'rails_helper'

RSpec.describe "Users can delete a favorite" do
  context "from the users favorites index page" do
    it "removes favorite when i click 'remove favorite' ", :vcr do
      @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210", token: ENV['SPOTIFY_TEMP_TOKEN'] )
      @artist1 = Artist.create(followers: 2900, name: "Colfax Speed Queen", zipcode: "80126", spotify_id: "3p9nYbFprckRkRxuCFVQcx", city: "Denver", state: "CO", genre: ["garage", "punk"])
      @artist2 = Artist.create(followers: 2900, name: "Joel Ansett", zipcode: "80126", spotify_id: "49IjdVEbQcukWy36sdRMzl", city: "Denver", state: "CO", genre: ["indie", "pop"])
      @artist3 = Artist.create(followers: 2900, name: "YaSe", zipcode: "80126", spotify_id: "7emRqFqumIU39rRPvK3lbE", city: "Denver", state: "CO", genre: ["pop"])
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      zipcode_stub = File.read('spec/fixtures/zipcodes/80210_radius_of_15.json')
      stub_request(:get, "https://localhost4567/zipradius?radius=15&zip=80210").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v1.0.1'
           }).
         to_return(status: 200, body: zipcode_stub, headers: {})

      visit 'api/v1/user'

      expect(current_path).to eq("/api/v1/preferences")

      fill_in :zipcode, with: '80210'

      click_on "Update Preferences"

      expect(current_path).to eq("/api/v1/dashboard")

      visit "/artists"

      click_on "Add Artist to Favorites"
      
      expect(current_path).to eq("/artists")
      artist = Artist.first
      expect(page).to have_content("#{artist.name} has been added to your favorites")

      expect(page).to have_link("#{@artist2.name}")
      click_on("#{@artist3.name}")

     
      click_on "Add Artist to Favorites"
     

      expect(page).to have_content("#{@artist3.name} has been added to your favorites")

      visit "/favorites"

      expect(page).to have_content(artist.name)
      expect(page).to have_content(@artist3.name)

      within ".artist-#{artist.id}" do
        click_on "Remove Favorite"
      end

      expect(current_path).to eq("/favorites")
      expect(page).to have_content("#{artist.name} has been removed from your favorites")
      expect(page).to_not have_css(".artist-#{artist.id}")
      expect(page).to have_css(".artist-#{@artist3.id}")
    end
  end
end
