require 'rails_helper'

RSpec.describe "Users can remove a favorite" do
  context "from the artists index page" do
    it "top displayed artist has a link nearby to add artist as favrotie", :vcr do
      @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210", token: ENV['SPOTIFY_TEMP_TOKEN'])
      @user2 = User.create(username: "Marty McFly", email: "marty@hotmail.com", zipcode: "80218", token: ENV['SPOTIFY_TEMP_TOKEN'])
      @artist1 = Artist.create(followers: 3333, name: "Colfax Speed Queen", zipcode: "80126", spotify_id: "3p9nYbFprckRkRxuCFVQcx", city: "Denver", state: "CO", genre: ["garage", "punk"])
      @artist2 = Artist.create(followers: 3333, name: "Joel Ansett", zipcode: "80126", spotify_id: "49IjdVEbQcukWy36sdRMzl", city: "Denver", state: "CO", genre: ["indie", "pop"])
      @artist3 = Artist.create(followers: 3333, name: "YaSe", zipcode: "80126", spotify_id: "7emRqFqumIU39rRPvK3lbE", city: "Denver", state: "CO", genre: ["pop"])
      @user_artist = UserArtist.create(user_id: @user1.id, artist_id: @artist1.id)
      @user_artist1 = UserArtist.create(user_id: @user2.id, artist_id: @artist1.id)
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      visit '/favorites'

      expect(page).to have_content(@artist1.name)

      click_on("Remove Favorite")

      expect(page).to have_content("#{@artist1.name} has been removed from your favorites")

      expect(page).to have_content("No Favorites... Yet")
    end
  end
end
