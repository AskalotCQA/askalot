class AddSharedThroughCategoryToCategoryQuestions < ActiveRecord::Migration
  def change
    add_column :categories_questions, :shared_through_category_id, :integer, index: true
  end
end
