class AddCategoryQuestionCounters < ActiveRecord::Migration
  def change
    add_column :categories, :direct_questions_count, :integer, :null => false, :default => 0
    add_column :categories, :direct_shared_questions_count, :integer, :null => false, :default => 0
    add_column :categories, :direct_answers_count, :integer, :null => false, :default => 0
    add_column :categories, :direct_shared_answers_count, :integer, :null => false, :default => 0
  end
end
