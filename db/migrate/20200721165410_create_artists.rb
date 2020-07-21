class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :artists do |t|
      t.string :zipcode
      t.string :city
      t.string :state
      t.string :name
      t.string :spotify_id
      t.string :genre, array: true, default: []

      t.timestamps
    end
  end
end
