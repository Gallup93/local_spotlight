class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :zipcode
      t.string :token
      t.string :refresh_token

      t.timestamps
    end
  end
end
