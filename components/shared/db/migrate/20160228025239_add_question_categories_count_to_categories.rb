class AddQuestionCategoriesCountToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :category_questions_count, :integer, :null => false, :default => 0
  end
end
