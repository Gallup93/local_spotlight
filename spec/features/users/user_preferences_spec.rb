require 'rails_helper'

RSpec.describe "User preferences", type: :feature do
  context "a new user without a zipcode is directed to '/preferences'" do
    it "can enter a valid zip" do

      @user = User.create(username: "Rocky McMountain", email: "LoveMusic303@aol.com")
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)
      visit "api/v1/preferences"

      expect(page).to have_content("Preferences:")
      expect(page).to have_content("Enter your zip to get started.")

      fill_in :zipcode, with: "80128"

      click_on "Update Preferences"

      expect(current_path).to eq("/api/v1/dashboard")
    end
  end
  context "an existing user can update thier zip" do
    it "can enter a valid zip" do

      @user = User.create(username: "Rocky McMountain", email: "LoveMusic303@aol.com", zipcode: 80128)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user)

      visit "/api/v1/preferences"
      expect(page).to have_content("Preferences:")
      expect(page).to have_content("Your current zip: 80128")

      fill_in :zipcode, with: "61109"

      click_on "Update Preferences"

      expect(current_path).to eq("/api/v1/dashboard")
      expect(page).to have_content("Your current zipcode: 61109")
    end
  end
end
