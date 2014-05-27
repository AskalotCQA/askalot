namespace :probe do
  namespace :import do
    desc 'Imports questions'
    task questions: :environment do
      Question.probe.index.import Question.all
    end
  end
end
