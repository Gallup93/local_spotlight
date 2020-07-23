require 'rails_helper'

RSpec.describe "As a user" do
  describe "when I visit the new artist page" do
    it "has a form that allows me to input a new local artist" do
      user = create(:user)
      
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)

      visit '/api/v1/dashboard' 
      
      click_on "Add New Artist" 
      
      expect(current_path).to eq(new_artist_path)
      
    end
  end
end