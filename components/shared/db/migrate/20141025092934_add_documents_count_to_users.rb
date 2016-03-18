class AddDocumentsCountToUsers < ActiveRecord::Migration
  def up
    add_counter :users, :documents
  end

  def down
    remove_counter :users, :documents
  end
end
