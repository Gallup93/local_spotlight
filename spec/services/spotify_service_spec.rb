require 'rails_helper'
RSpec.describe SpotifyService do

  before :each do 
    @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210" )
    @artist_1 = Artist.create(name: "Ramakhandra", description: "A very cool band", zipcode: "80216", spotify_id: "1Apw9xiab11PyZLo6YeUoJ", city: "Denver", state: "CO", genre: ["electronic", "psychedelic"])
    @artist_2 = Artist.create(name: "Smirk", zipcode: "80126", spotify_id: "3pwiEWINB62yhDUUODnHLj", city: "Denver", state: "CO", genre: ["instrumental", "jazz"])
    @artist_3 = Artist.create(name: "American Grandma", description: "A very cool band", zipcode: "80126", spotify_id: "4XTcP25C5ZUWpwf0NYGJnn", city: "Denver", state: "CO", genre: ["mellow"])
    @artist_4 = Artist.create(name: "Oko Tygra", zipcode: "80126", spotify_id: "0K7C1TRrshf9PGeOmnwtDe", city: "Denver", state: "CO", genre: ["electronic"])
    @artist_5 = Artist.create(name: "Nightmare Blue", zipcode: "80126", spotify_id: "e", city: "Denver", state: "CO", genre: ["rock", "garage-rock"])
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  end 
  
  it "test that service is providing the correct info" do 
    artist_albums = File.read('spec/fixtures/artist_albums.json')
    stub_request(:get, "https://api.spotify.com/v1/artists/1Apw9xiab11PyZLo6YeUoJ/albums").
         with(
           headers: {
          'Accept'=>'*/*',
          'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'Authorization'=>'Bearer',
          'User-Agent'=>'Faraday v1.0.1'
           }).
         to_return(status: 200, body: artist_albums, headers: {})
    
    
    service = SpotifyService.new
    search = service.albums(@artist_1, @user1.token)
    keys = search[:items].first.keys
    expect(search).to be_a Hash
    expect(search[:items].first.keys).to eq(keys)
    expect(search[:items].first).to have_key :name
    expect(search[:items].first).to have_key :id


  end 
end