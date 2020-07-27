class FavoritesController < ApplicationController
  def index
    @favorite_artists = current_user.user_artists
  end

  def new
    if UserArtist.create(user_id: current_user[:id], artist_id: params["id"])
      flash[:success] = "#{find_artist_by_id(params["id"]).name} has been added to your favorites"
      redirect_to request.referrer
      #look at fixing the refresh problem with JavaScript  
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
