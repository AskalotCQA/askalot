namespace :categories_questions do
  desc "Reload table content"
  task reload: :environment do
    puts "Deleting old data"
    Shared::CategoryQuestion.delete_all
    Shared::Question.all.each do |question|
      puts "Inserting question #{question.id}"
      if question.category
        question.category.self_and_ancestors.each do |ancestor|
          puts "\t\tInserting into parent categoy #{ancestor.id} - #{ancestor.name}"
          Shared::CategoryQuestion.create question_id: question.id, category_id: ancestor.id, shared: false
        end
        question.category.all_versions.shared.each do |shared|
          puts "\t\t\tInserting into shared category #{shared.id} - #{shared.name}"
          shared.self_and_ancestors.each do |c|
            Shared::CategoryQuestion.create question_id: question.id, category_id: c.id, shared: true
          end
        end
      end
    end
  end
end
