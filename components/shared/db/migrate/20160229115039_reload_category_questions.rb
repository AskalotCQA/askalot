class ReloadCategoryQuestions < ActiveRecord::Migration
  def up
    Rake::Task['categories_questions:reload'].invoke
  end
end
