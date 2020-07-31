require 'rails_helper'

RSpec.describe "As a visitor" do
  describe "welcome page" do
    it "has a link to login with Spotify using Oauth" do
      visit "/"

      expect(page).to have_link('Login with Spotify')

      within '#login' do
        expect {click_link("Login with Spotify")}.to raise_error(ActionController::RoutingError)
      end
    end
    it "can log out" do
      user = User.create(username: "Rocky McMountain", email: "LoveMusic303@aol.com", zipcode: "80128",  token: ENV['SPOTIFY_TEMP_TOKEN'])
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/'
      click_link("Logout")

      expect(page).to have_content("You have been logged out")
    end
  end
end
