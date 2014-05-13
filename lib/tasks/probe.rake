namespace :probe do
  namespace :import do

    desc 'Imports all'
    task all: :environment do
      Rake::Task['probe:import:questions'].invoke
      Rake::Task['probe:import:answers'].invoke
      Rake::Task['probe:import:comments'].invoke
    end

    desc 'Imports questions'
    task questions: :environment do
      Question.probe.index.import Question.all
    end

    desc 'Imports answers'
    task answers: :environment do
      Answer.probe.index.import Answer.all
    end

    desc 'Imports comments'
    task comments: :environment do
      Comment.probe.index.import Comment.all
    end
  end
end
