class FavoritesController < ApplicationController
  def index
    @favorite_artists = current_user.user_artists
  end

  def new
    favorite = UserArtist.where(user_id: current_user.id, artist_id: params[:id])
    if favorite == []
      UserArtist.create(user_id: current_user.id, artist_id: params[:id])
      @favorite_exists = true
    else
      favorite.destroy_all
      @favorite_exists = false
    end
    respond_to do |format|
      format.html {}
      format.js {}
    end
  end

  def destroy
    favorite = UserArtist.find(params[:id])
    name = Artist.find(favorite.artist_id).name
    current_user.user_artists.delete(favorite.id)
    favorite.delete
    flash[:success] = "#{name} has been removed from your favorites"
    redirect_to "/favorites"
  end
end
