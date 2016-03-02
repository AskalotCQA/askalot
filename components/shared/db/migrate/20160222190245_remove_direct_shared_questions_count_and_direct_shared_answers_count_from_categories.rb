class RemoveDirectSharedQuestionsCountAndDirectSharedAnswersCountFromCategories < ActiveRecord::Migration
  def change
    remove_column :categories, :direct_shared_questions_count, :integer, :null => false, :default => 0
    remove_column :categories, :direct_shared_answers_count, :integer, :null => false, :default => 0
  end
end
