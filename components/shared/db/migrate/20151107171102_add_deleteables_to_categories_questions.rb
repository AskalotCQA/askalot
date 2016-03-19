class AddDeleteablesToCategoriesQuestions < ActiveRecord::Migration
  def change
    add_column :categories_questions, :deleted, :boolean, null: false, default: false
    add_reference :categories_questions, :deletor, null: true, index: true
    add_column :categories_questions, :deleted_at, :timestamp
  end
end
