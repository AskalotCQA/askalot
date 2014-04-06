require 'profile'
require_relative '../../app/services/events/dispatcher'


namespace :profile do
  desc 'Feeds all resources'
  task feed: :environment do
    Rake::Task['profile:questions:feed'].invoke
    Rake::Task['profile:answers:feed'].invoke
    Rake::Task['profile:votes:feed'].invoke
    Rake::Task['profile:views:feed'].invoke
    Rake::Task['profile:comments:feed'].invoke
    Rake::Task['profile:labels:feed'].invoke
  end

  desc 'Prepare dispatcher'
  task prepare: :environment do
    Events::Dispatcher.unsubscribe_all

    Events::Dispatcher.subscribe Profile::QuestionFeeder
    Events::Dispatcher.subscribe Profile::AnswerFeeder
    Events::Dispatcher.subscribe Profile::UserFeeder
  end

  namespace :questions do
    desc 'Feeds questions'
    task feed: :environment do
      Rake::Task['profile:prepare'].invoke

      Question.find_each do |question|
        Timecop.freeze(question.created_at) do
          Events::Dispatcher.dispatch(:create, question.author, question)
        end
      end
    end
  end

  namespace :answers do
    desc 'Feeds answers'
    task feed: :environment do
      Rake::Task['profile:prepare'].invoke

      Answer.find_each do |answer|
        Timecop.freeze(answer.created_at) do
          Events::Dispatcher.dispatch(:create, answer.author, answer)
        end
      end
    end
  end

  namespace :votes do
    desc 'Feeds votes'
    task feed: :environment do
      Rake::Task['profile:prepare'].invoke

      Vote.find_each do |vote|
        Timecop.freeze(vote.created_at) do
          Events::Dispatcher.dispatch(:create, vote.voter, vote)
        end
      end
    end
  end

  namespace :views do
    desc 'Feeds views'
    task feed: :environment do
      Rake::Task['profile:prepare'].invoke

      View.find_each do |view|
        Timecop.freeze(view.created_at) do
          Events::Dispatcher.dispatch(:create, view.viewer, view)
        end
      end
    end
  end

  namespace :comments do
    desc 'Feeds comments'
    task feed: :environment do
      Rake::Task['profile:prepare'].invoke

      Comment.find_each do |comment|
        Timecop.freeze(comment.created_at) do
          Events::Dispatcher.dispatch(:create, comment.author, comment)
        end
      end
    end
  end

  namespace :labels do
    desc 'Feeds labels'
    task feed: :environment do
      Rake::Task['profile:prepare'].invoke

      Labeling.find_each do |labeling|
        Timecop.freeze(labeling.created_at) do
          Events::Dispatcher.dispatch(:create, labeling.author, labeling)
        end
      end
    end
  end
end
