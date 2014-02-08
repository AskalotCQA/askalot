class AddImportIds < ActiveRecord::Migration
  def change
    add_column :users, :imported_id, :integer
    add_column :questions, :imported_id, :integer
    add_column :answers, :imported_id, :integer
    add_column :comments, :imported_id, :integer
  end
end
