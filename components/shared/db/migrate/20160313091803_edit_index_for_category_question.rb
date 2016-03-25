class EditIndexForCategoryQuestion < ActiveRecord::Migration
  def change
    remove_index :categories_questions, [:question_id, :category_id]
    add_index :categories_questions, [:question_id, :category_id, :shared_through_category_id], name: 'index_for_unique_category_questions'
  end
end
