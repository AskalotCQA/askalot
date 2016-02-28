namespace :categories_questions do
  desc "Reload table content"
  task reload: :environment do
    Shared::CategoryQuestion.delete_all
    Shared::Question.all.each do |question|
      question.register_question
    end
  end
end
