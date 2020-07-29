require 'rails_helper'
RSpec.describe "As a registered user, when I visit the artists index page" do
  before(:each) do
    @user = User.create!(username: "Mahatma123", email: 'mahatma@example.com', zipcode: '61109',
                         token: ENV['SPOTIFY_TEMP_TOKEN'])
    @artist = Artist.create!(followers: 33, name: "Ramakhandra", zipcode: "80216", spotify_id: "1Apw9xiab11PyZLo6YeUoJ", city: "Denver", state: "CO", genre: ["electronic", "psychedelic"])
    @artist1 = Artist.create!(followers: 33, name: "Smirk", zipcode: "80126", spotify_id: "3pwiEWINB62yhDUUODnHLj", city: "Denver", state: "CO", genre: ["instrumental", "jazz"])
    @artist2 = Artist.create!(followers: 33, name: "American Grandma", zipcode: "80126", spotify_id: "4XTcP25C5ZUWpwf0NYGJnn", city: "Denver", state: "CO", genre: ["mellow"])
    @artist3 = Artist.create!(followers: 33, name: "Oko Tygra", zipcode: "80126", spotify_id: "0K7C1TRrshf9PGeOmnwtDe", city: "Denver", state: "CO", genre: ["electronic"])
    @artist4 = Artist.create!(followers: 33, name: "Nightmare Blue", zipcode: "80126", spotify_id: "55YvlSWn4tljj2aEP086Cm", city: "Denver", state: "CO", genre: ["rock", "garage-rock"])
    @artist5 = Artist.create!(followers: 33, name: "Vic N' the Narwhals", zipcode: "61109", spotify_id: "0562KfT4fpu6sF69JykFDI", city: "Denver", state: "CO", genre: ["latin", "psychedelic"])
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
  end
  it "then I see all of the artists in the database", :vcr do
    visit 'api/v1/user'

    expect(current_path).to eq("/api/v1/preferences")

    fill_in :zipcode, with: '61109'

    click_on "Update Preferences"

    expect(current_path).to eq("/api/v1/dashboard")

    visit '/artists'

    within '.artist-header' do
      expect(page).to have_content(@artist5.name)
    end

    expect(page).to_not have_link(@artist1.name)
    expect(page).to_not have_link(@artist2.name)
    expect(page).to_not have_link(@artist3.name)
    expect(page).to_not have_link(@artist4.name)

  end
  it "I can provide a zipcode to browse artists in new areas", :vcr do

    visit 'api/v1/user'

    expect(current_path).to eq("/api/v1/preferences")

    fill_in :zipcode, with: '61109'

    click_on "Update Preferences"

    expect(current_path).to eq("/api/v1/dashboard")

    visit '/artists'

    expect(page).to have_content "Currently browsing Artists within 15 Miles of Zipcode: 61109"

    within ".update-temp-zip" do
      fill_in :zipcode, with: 80126
      click_on "Explore"
    end
    within ".preference-header" do
      expect(page).to have_content "Zipcode: 80126"
    end
    expect(page).to_not have_link(@artist5.name)

    expect(page).to have_link(@artist1.name)
    expect(page).to have_link(@artist2.name)
    expect(page).to have_link(@artist3.name)
    expect(page).to have_link(@artist4.name)

    expect(@user.zipcode).to eq("61109")
  end
end
