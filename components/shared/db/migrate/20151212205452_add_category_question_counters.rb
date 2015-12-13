class AddCategoryQuestionCounters < ActiveRecord::Migration
  def change
    add_column :categories, :direct_questions_count, :integer
    add_column :categories, :direct_shared_questions_count, :integer
    add_column :categories, :direct_answers_count, :integer
    add_column :categories, :direct_shared_answers_count, :integer
  end
end
