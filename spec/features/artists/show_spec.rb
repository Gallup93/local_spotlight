require 'rails_helper'
RSpec.describe 'Artist show page', type: :feature do 
    before :each do 
        @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210" )
        @artist_1 = Artist.create(name: "Ramakhandra", zipcode: "80216", spotify_id: "1Apw9xiab11PyZLo6YeUoJ", city: "Denver", state: "CO", genre: ["electronic", "psychedelic"])
        @artist_2 = Artist.create(name: "Smirk", zipcode: "80126", spotify_id: "3pwiEWINB62yhDUUODnHLj", city: "Denver", state: "CO", genre: ["instrumental", "jazz"])
        @artist_3 = Artist.create(name: "American Grandma", zipcode: "80126", spotify_id: "4XTcP25C5ZUWpwf0NYGJnn", city: "Denver", state: "CO", genre: ["mellow"])
        @artist_4 = Artist.create(name: "Oko Tygra", zipcode: "80126", spotify_id: "0K7C1TRrshf9PGeOmnwtDe", city: "Denver", state: "CO", genre: ["electronic"])
        @artist_5 = Artist.create(name: "Nightmare Blue", zipcode: "80126", spotify_id: "55YvlSWn4tljj2aEP086Cm", city: "Denver", state: "CO", genre: ["rock", "garage-rock"])
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    end 
    
    it 'Artist information is visible on the artist show page' do 
      visit "/artist/#{@artist_1.id}"  

      within ".top-tracks" do
        "#{@artist.name} Top Tracks"
      end 

      within ".albums" do 
        "albums"
      end 
    
    end 

end