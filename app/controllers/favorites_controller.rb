class FavoritesController < ApplicationController
  def index
    @favorite_artists = current_user.user_artists
  end

  def new
    if UserArtist.create(user_id: current_user[:id], artist_id: params["id"])
      flash[:success] = "#{find_artist_by_id(params["id"]).name} has been added to your favorites"
      redirect_to request.referrer
    end
  end
end
