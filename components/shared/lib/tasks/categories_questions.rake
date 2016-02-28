namespace :categories_questions do
  desc "Reload table content"
  task reload: :environment do
    Shared::Category.roots.each do |root|
      root.reload_categories_questions
    end
  end
end
