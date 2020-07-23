class FavoritesController < ApplicationController 
    def index 
        @favorite_artists = current_user.user_artists
     
    end 
end 