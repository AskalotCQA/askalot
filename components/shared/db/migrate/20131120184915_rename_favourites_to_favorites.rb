class RenameFavouritesToFavorites < ActiveRecord::Migration
  def change
    rename_table :favourites, :favorites
  end
end
