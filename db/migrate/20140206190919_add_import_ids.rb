class AddImportIds < ActiveRecord::Migration
  def change
    add_column :users, :imported_id, :integer
    add_index :users, :imported_id

    add_column :questions, :imported_id, :integer
    add_index :questions, :imported_id

    add_column :answers, :imported_id, :integer
    add_index :answers, :imported_id

    add_column :comments, :imported_id, :integer
    add_index :comments, :imported_id
  end
end
