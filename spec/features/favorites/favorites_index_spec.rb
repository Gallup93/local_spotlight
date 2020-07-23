require 'rails_helper'
RSpec.describe 'user favorites page', type: :feature do 
    
    before :each do
        @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210" )
        @user2 = User.create(username: "Guy McMusic", email: "Guy!!!@hotmail.com", zipcode: "80210" )
        @artist_1 = Artist.create(name: "Ramakhandra", zipcode: "80216", spotify_id: "1Apw9xiab11PyZLo6YeUoJ", city: "Denver", state: "CO", genre: ["electronic", "psychedelic"])
        @artist_2 = Artist.create(name: "Smirk", zipcode: "80126", spotify_id: "3pwiEWINB62yhDUUODnHLj", city: "Denver", state: "CO", genre: ["instrumental", "jazz"])
        @artist_3 = Artist.create(name: "American Grandma", zipcode: "80126", spotify_id: "4XTcP25C5ZUWpwf0NYGJnn", city: "Denver", state: "CO", genre: ["mellow"])
        @artist_4 = Artist.create(name: "Oko Tygra", zipcode: "80126", spotify_id: "0K7C1TRrshf9PGeOmnwtDe", city: "Denver", state: "CO", genre: ["electronic"])
        @artist_5 = Artist.create(name: "Nightmare Blue", zipcode: "80126", spotify_id: "55YvlSWn4tljj2aEP086Cm", city: "Denver", state: "CO", genre: ["rock", "garage-rock"])
        allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
    end 

    it "User favorites are displayed correctly on favorites index page" do 
        UserArtist.create(user_id: @user1.id, artist_id: @artist_1.id)
        UserArtist.create(user_id: @user1.id, artist_id: @artist_2.id)
        UserArtist.create(user_id: @user2.id, artist_id: @artist_4.id)
        UserArtist.create(user_id: @user2.id, artist_id: @artist_5.id)

        visit '/favorites'
        within ".favorite-bands" do 
            within ".artist-#{@artist_1.id}" do 
                expect(page).to have_content(@artist_1.name)
                expect(page).to have_content(@artist_1.city)
                expect(page).to have_content(@artist_1.state)
                expect(page).to have_content(@artist_1.zipcode)
            end 
            within ".artist-#{@artist_2.id}" do 
                expect(page).to have_content(@artist_2.name)
                expect(page).to have_content(@artist_2.city)
                expect(page).to have_content(@artist_2.state)
                expect(page).to have_content(@artist_2.zipcode)
            end 
            expect(page).to_not have_content(@artist_4.name)
        end 
    end 

    it "Sad path for favorites - if no artists have been favorited" do 
        visit '/favorites'
        
        within ".favorite-bands" do
            expect(page).to have_content("No Favorites... Yet")
        end 

    end 
end