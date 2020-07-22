require 'rails_helper'

RSpec.describe "User dashboard", type: :feature do
  before :each do
    @artist1 = Artist.create(name: "Ramakhandra", zipcode: "80216", spotify_id: "1Apw9xiab11PyZLo6YeUoJ", city: "Denver", state: "CO", genre: ["electronic", "psychedelic"])
    @artist2 = Artist.create(name: "Smirk", zipcode: "80126", spotify_id: "3pwiEWINB62yhDUUODnHLj", city: "Denver", state: "CO", genre: ["instrumental", "jazz"])

    @user1 = User.create(username: "Rocky McMountain", email: "LoveMusic303@aol.com", zipcode: "80128")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  end

  it "displays users username" do
    visit "/api/v1/dashboard"

    within ".user-info" do
      expect(page).to have_content("Hello, #{@user1.username}")
      expect(page).to have_content("Your current zipcode: #{@user1.zipcode}")
    end
  end

  it "displays default message if user has no favorites" do
    visit "/api/v1/dashboard"

    within ".favorite-artists" do
      expect(page).to have_content("No Favorite Artists... yet")
    end
  end

  it "displays users favorite artists" do
    UserArtist.create(user_id: @user1.id, artist_id: @artist2.id)
    visit "/api/v1/dashboard"

    within ".favorite-artists" do
      expect(page).to have_link(@artist2.name)
      expect(page).to_not have_link(@artist1.name)

      # artist show page doesnt exist yet...
      
      # click_link "#{@artist2.name}"
      # expect(current_path).to eq("/artists/#{@artist2.id}")
    end
  end
end
