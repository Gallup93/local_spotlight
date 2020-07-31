require 'rails_helper'

RSpec.describe "Users can add a favorite" do
  context "from the artists index page" do
    it "top displayed artist has a link nearby to add artist as favrotie", :vcr do
      @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210", token: ENV['SPOTIFY_TEMP_TOKEN'])
      @artist1 = Artist.create(followers: 3333, name: "Colfax Speed Queen", zipcode: "80126", spotify_id: "3p9nYbFprckRkRxuCFVQcx", city: "Denver", state: "CO", genre: ["garage", "punk"])
      @artist2 = Artist.create(followers: 3333, name: "Joel Ansett", zipcode: "80126", spotify_id: "49IjdVEbQcukWy36sdRMzl", city: "Denver", state: "CO", genre: ["indie", "pop"])
      @artist3 = Artist.create(followers: 3333, name: "YaSe", zipcode: "80126", spotify_id: "7emRqFqumIU39rRPvK3lbE", city: "Denver", state: "CO", genre: ["pop"])
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      zipcode_stub = File.read('spec/fixtures/zipcodes/80126_radius_of_15.json')

      stub_request(:get, "https://frozen-sierra-74026.herokuapp.com/zipradius?radius=15&zip=80210").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v1.0.1'
           }).
         to_return(status: 200, body: zipcode_stub, headers: {})

      visit 'api/v1/user'

      expect(current_path).to eq("/api/v1/preferences")

      fill_in :zipcode, with: '80126'

      click_on "Update Preferences"

      expect(current_path).to eq("/api/v1/dashboard")

      visit "/artists"

      
      click_link "Add Artist to Favorites"
      
      expect(current_path).to eq("/artists")
      expect(page).to have_content("#{@artist1.name} has been added to your favorites")

      expect(page).to have_link("#{@artist2.name}")

      click_link "#{@artist3.name}"
    
      click_link "Add Artist to Favorites"
      
      expect(page).to have_content("#{@artist3.name} has been added to your favorites")

      visit "/favorites"

      expect(page).to have_content(@artist1.name)
      expect(page).to have_content(@artist3.name)
    end

    it "wont display 'FAV' link if artist is already favorited", :vcr do
      @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210", token: ENV['SPOTIFY_TEMP_TOKEN'])
      @artist1 = Artist.create(followers: 6565, name: "Colfax Speed Queen", zipcode: "80126", spotify_id: "3p9nYbFprckRkRxuCFVQcx", city: "Denver", state: "CO", genre: ["garage", "punk"])
      @artist2 = Artist.create(followers: 6565, name: "Joel Ansett", zipcode: "80126", spotify_id: "49IjdVEbQcukWy36sdRMzl", city: "Denver", state: "CO", genre: ["indie", "pop"])
      @artist3 = Artist.create(followers: 6565, name: "YaSe", zipcode: "80126", spotify_id: "7emRqFqumIU39rRPvK3lbE", city: "Denver", state: "CO", genre: ["pop"])
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      zipcode_stub = File.read('spec/fixtures/zipcodes/80126_radius_of_15.json')

      stub_request(:get, "https://localhost4567/zipradius?radius=15&zip=80210").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent'=>'Faraday v1.0.1'
           }).
         to_return(status: 200, body: zipcode_stub, headers: {})

       album_stub = File.read('spec/fixtures/artist_albums.json')

       stub_request(:get, "https://api.spotify.com/v1/artists/3p9nYbFprckRkRxuCFVQcx/albums").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer',
          'User-Agent'=>'Faraday v1.0.1'
           }).
        to_return(status: 200, body: album_stub, headers: {})

      visit 'api/v1/user'

      expect(current_path).to eq("/api/v1/preferences")

      fill_in :zipcode, with: '80126'

      click_on "Update Preferences"

      expect(current_path).to eq("/api/v1/dashboard")

      visit "/artists"
   
      click_link "Add Artist to Favorites"
      
      expect(current_path).to eq("/artists")
      expect(page).to have_content("#{@artist1.name} has been added to your favorites")
      expect(page).to_not have_link("Add Artist to Favorites")

      click_link "#{@artist3.name}"

      expect(page).to have_link("Add Artist to Favorites")
    end

    it "user can add artist to favorite from show page", :vcr do
        artist_albums = File.read('spec/fixtures/artist_albums.json')
        stub_request(:get, "https://api.spotify.com/v1/artists/3p9nYbFprckRkRxuCFVQcx/albums").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer',
          'User-Agent'=>'Faraday v1.0.1'
           }).
         to_return(status: 200, body: artist_albums, headers: {})

      @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210", token: ENV['SPOTIFY_TEMP_TOKEN'])
      @artist1 = Artist.create(followers: 7788, name: "Colfax Speed Queen", zipcode: "80126", spotify_id: "3p9nYbFprckRkRxuCFVQcx", city: "Denver", state: "CO", genre: ["garage", "punk"])
      @artist2 = Artist.create(followers: 7788, name: "Joel Ansett", zipcode: "80126", spotify_id: "49IjdVEbQcukWy36sdRMzl", city: "Denver", state: "CO", genre: ["indie", "pop"])
      @artist3 = Artist.create(followers: 7788, name: "YaSi", zipcode: "80126", spotify_id: "7emRqFqumIU39rRPvK3lbE", city: "Denver", state: "CO", genre: ["pop"])

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

     fill_in :zipcode, with: '80126'

     click_on "Update Preferences"

     expect(current_path).to eq("/api/v1/dashboard")

      artist = Artist.first

      visit "/artists"

      within ".artist-header" do
        click_on artist.name
      end

      click_on "Add Artist to Favorites"
      visit "/favorites"

      expect(page).to have_content(artist.name)
    end
  end
end
