require 'rails_helper'

RSpec.describe "As a user" do
  before(:each) do
    @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210",
                         token: "BQAIJ8HsaN5CrY2kEopYq2Mc2dOvQpC-XesCuttVv78Oz_QJOAKNxIk2fzwAdD-UFbGErlaCJY_1cQFJcA-M0gQ2yg8-YeqF6tXq0J1Z4np9YY0x6xwcPGwIUnJu-SUdit6LZLhhZfTgj2t0cyG3N4BBi5JIBJ5rIn-xZ-8Ag_YJcwqiT_rbflPFYyF9aL2Q")

    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)
  end
  describe "when I visit the new artist page" do
    it "has a form that allows me to input a new local artist", :vcr do

      visit '/api/v1/dashboard'

      click_on "Add New Artist"

      expect(current_path).to eq(new_artist_path)

      fill_in "name", with: "Smirk"
      fill_in "spotify_id", with: '3pwiEWINB62yhDUUODnHLj'
      fill_in "zipcode", with: '80126'
      fill_in 'description', with: 'New Age Funk'

      check 'Rock & Roll'
      check 'Jazz'
      check 'Blues'

      click_on("Add Artist")

      artist = Artist.last

      expect(current_path).to eq(artist_path(artist))

      expect(page).to have_content(artist.name)
      expect(page).to have_content(artist.description)
      
      expect(page).to have_css('.player')
    end
  end
end
