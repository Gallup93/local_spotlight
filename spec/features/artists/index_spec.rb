require 'rails_helper'
RSpec.describe "As a registered user, when I visit the artists index page" do
  before(:each) do
    @user = User.create!(username: "Mahatma123", email: 'mahatma@example.com', zipcode: '61109')
    @artist = Artist.create(name: "Ramakhandra", zipcode: "80216", spotify_id: "1Apw9xiab11PyZLo6YeUoJ", city: "Denver", state: "CO", genre: ["electronic", "psychedelic"])
    @artist1 = Artist.create(name: "Smirk", zipcode: "80126", spotify_id: "3pwiEWINB62yhDUUODnHLj", city: "Denver", state: "CO", genre: ["instrumental", "jazz"])
    @artist2 = Artist.create(name: "American Grandma", zipcode: "80126", spotify_id: "4XTcP25C5ZUWpwf0NYGJnn", city: "Denver", state: "CO", genre: ["mellow"])
    @artist3 = Artist.create(name: "Oko Tygra", zipcode: "80126", spotify_id: "0K7C1TRrshf9PGeOmnwtDe", city: "Denver", state: "CO", genre: ["electronic"])
    @artist4 = Artist.create(name: "Nightmare Blue", zipcode: "80126", spotify_id: "55YvlSWn4tljj2aEP086Cm", city: "Denver", state: "CO", genre: ["rock", "garage-rock"])
    @artist5 = Artist.create(name: "Vic N' the Narwhals", zipcode: "61109", spotify_id: "0562KfT4fpu6sF69JykFDI", city: "Denver", state: "CO", genre: ["latin", "psychedelic"])
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    #allow_any_instance_of(ApplicationController).to receive(:artists_nearby).and_return([@artist1, @artist2, @artist3, @artist4])
  end
  it "then I see all of the artists in the database" do  
    zipcode_stub = File.read('spec/fixtures/zipcodes/61109_radius_of_15.json')
    acc = stub_request(:get, "http://localhost:4567/zipradius?radius=15&zip=61109").
    with(
      headers: {
        'Accept'=>'*/*',
        'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
        'User-Agent'=>'Faraday v1.0.1'
        }).
        to_return(status: 200, body: zipcode_stub, headers: {})
      
    visit '/artists'
  
    within '.artist-header' do
      expect(page).to have_content(@artist5.name)
    end

    expect(page).to_not have_link(@artist1.name)  
    expect(page).to_not have_link(@artist2.name)   
    expect(page).to_not have_link(@artist3.name)  
    expect(page).to_not have_link(@artist4.name)
 
  end
  it "I can provide a zipcode to browse artists in new areas" do
    zipcode_stub = File.read('spec/fixtures/zipcodes/80126_radius_of_15.json')
    stub_request(:get, "http://localhost:4567/zipradius?radius=15&zip=61109").
      with(
        headers: {
      'Accept'=>'*/*',
      'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
      'User-Agent'=>'Faraday v1.0.1'
        }).
      to_return(status: 200, body: zipcode_stub, headers: {})
    visit '/artists'

    expect(page).to have_content "Currently Browsing Zipcode:"

    within ".update-temp-zip" do
      fill_in :zipcode, with: 80126
      click_on "Explore"
    end

    expect(page).to have_content "Currently Browsing Zipcode: 80126"
    expect(page).to_not have_link(@artist5.name)
    expect(@user.zipcode).to eq("61109")
  end
end
