class AddApiParamsToArtists < ActiveRecord::Migration[5.2]
  def change
    add_column :artists, :followers, :bigint
    add_column :artists, :images, :text, array: true, default: []
  end
end
