require 'rails_helper'

RSpec.describe "As a visitor" do
  describe "welcome page" do
    it "has a link to login with Spotify using Oauth" do
      visit "/"

      expect(page).to have_link('Login with Spotify')

      expect {click_link("Login with Spotify")}.to raise_error(ActionController::RoutingError)
    end
  end
end
