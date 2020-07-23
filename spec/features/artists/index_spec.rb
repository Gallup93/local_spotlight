require 'rails_helper'
RSpec.describe "As a registered user, when I visit the artists index page" do
  before(:each) do
    @user = User.create!(username: "Mahatma123", email: 'mahatma@example.com', zipcode: '32333')
    @artist = Artist.create(name: "Ramakhandra", zipcode: "80216", spotify_id: "1Apw9xiab11PyZLo6YeUoJ", city: "Denver", state: "CO", genre: ["electronic", "psychedelic"])
    @artist1 = Artist.create(name: "Smirk", zipcode: "80126", spotify_id: "3pwiEWINB62yhDUUODnHLj", city: "Denver", state: "CO", genre: ["instrumental", "jazz"])
    @artist2 = Artist.create(name: "American Grandma", zipcode: "80126", spotify_id: "4XTcP25C5ZUWpwf0NYGJnn", city: "Denver", state: "CO", genre: ["mellow"])
    @artist3 = Artist.create(name: "Oko Tygra", zipcode: "80126", spotify_id: "0K7C1TRrshf9PGeOmnwtDe", city: "Denver", state: "CO", genre: ["electronic"])
    @artist4 = Artist.create(name: "Nightmare Blue", zipcode: "80126", spotify_id: "55YvlSWn4tljj2aEP086Cm", city: "Denver", state: "CO", genre: ["rock", "garage-rock"])
    @artist5 = Artist.create(name: "Vic N' the Narwhals", zipcode: "80126", spotify_id: "0562KfT4fpu6sF69JykFDI", city: "Denver", state: "CO", genre: ["latin", "psychedelic"])
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
    allow_any_instance_of(User).to receive(:find_closest_artists).and_return([@artist1, @artist2, @artist3, @artist4])
  end
  it "then I see all of the artists in the database" do
    visit '/artists'

    within '.artist-header' do
      expect(page).to have_content(@artist1.name)
    end

    within "#artist-#{@artist1.id}" do
      expect(page).to have_link(@artist1.name)
    end

    within "#artist-#{@artist2.id}" do
      expect(page).to have_link(@artist2.name)
    end

    within "#artist-#{@artist3.id}" do
      expect(page).to have_link(@artist3.name)
    end

    within "#artist-#{@artist4.id}" do
      expect(page).to have_link(@artist4.name)
      click_link(@artist4.name)
    end

    expect(current_path).to eq("/artists")

    within '.artist-header' do
      expect(page).to have_content(@artist4.name)
    end
  end
end
