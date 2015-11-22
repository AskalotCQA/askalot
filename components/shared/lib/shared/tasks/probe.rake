namespace :probe do
  namespace :import do
    desc 'Imports questions'
    task questions: :environment do
      Shared::Question.probe.index.import Question.all
    end
  end
end
