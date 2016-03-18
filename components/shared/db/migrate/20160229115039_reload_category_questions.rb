class ReloadCategoryQuestions < ActiveRecord::Migration
  def up
    Shared::Category.roots.each do |root|
      root.reload_categories_questions
    end
  end
end
