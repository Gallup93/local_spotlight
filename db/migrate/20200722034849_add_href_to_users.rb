class AddHrefToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :href, :string
  end
end
