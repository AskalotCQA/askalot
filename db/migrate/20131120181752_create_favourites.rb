class CreateFavourites < ActiveRecord::Migration
  def change
    create_table :favourites do |t|
      t.references :user,     null: false
      t.references :question, null: false

      t.timestamps
    end

    add_index :favourites, :user_id
    add_index :favourites, :question_id
  end
end
