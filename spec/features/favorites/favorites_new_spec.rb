require 'rails_helper'

RSpec.describe "Users can add a favorite" do
  context "from the artists index page" do
    it "top displayed artist has a link nearby to add artist as favrotie" do
      @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210" )
      @artist1 = Artist.create(name: "Colfax Speed Queen", zipcode: "80126", spotify_id: "3p9nYbFprckRkRxuCFVQcx", city: "Denver", state: "CO", genre: ["garage", "punk"])
      @artist2 = Artist.create(name: "Joel Ansett", zipcode: "80126", spotify_id: "49IjdVEbQcukWy36sdRMzl", city: "Denver", state: "CO", genre: ["indie", "pop"])
      @artist3 = Artist.create(name: "YaSi", zipcode: "80126", spotify_id: "7emRqFqumIU39rRPvK3lbE", city: "Denver", state: "CO", genre: ["pop"])
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      visit "/artists"

      within ".fav-link" do
        click_link "FAV"
      end
      expect(current_path).to eq("/artists")
      expect(page).to have_content("#{@artist1.name} has been added to your favorites")

      expect(page).to have_link("#{@artist2.name}")
      click_link "#{@artist3.name}"

      within ".fav-link" do
        click_link "FAV"
      end

      expect(page).to have_content("#{@artist3.name} has been added to your favorites")

      visit "/favorites"

      expect(page).to have_content(@artist1.name)
      expect(page).to have_content(@artist3.name)
    end
    it "wont display 'FAV' link if artist is already facortied" do
      @user1 = User.create(username: "Music McMusic", email: "music@hotmail.com", zipcode: "80210" )
      @artist1 = Artist.create(name: "Colfax Speed Queen", zipcode: "80126", spotify_id: "3p9nYbFprckRkRxuCFVQcx", city: "Denver", state: "CO", genre: ["garage", "punk"])
      @artist2 = Artist.create(name: "Joel Ansett", zipcode: "80126", spotify_id: "49IjdVEbQcukWy36sdRMzl", city: "Denver", state: "CO", genre: ["indie", "pop"])
      @artist3 = Artist.create(name: "YaSi", zipcode: "80126", spotify_id: "7emRqFqumIU39rRPvK3lbE", city: "Denver", state: "CO", genre: ["pop"])
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(@user1)

      visit "/artists"

      within ".fav-link" do
        click_link "FAV"
      end

      expect(current_path).to eq("/artists")
      expect(page).to have_content("#{@artist1.name} has been added to your favorites")
      expect(page).to_not have_link("FAV")
      click_link "#{@artist3.name}"
      expect(page).to have_link("FAV")
    end
  end
end
