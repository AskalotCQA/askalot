require_relative '../../app/services/events/dispatcher'

namespace :generators do
  desc 'Prepare dispatcher'
  task activties: :environment do
    [Question, Answer, Comment, Labeling, Evaluation].each do |model|
      model.class_eval do
        alias :initiator :author
      end
    end

    Vote.class_eval do
      alias :initiator :voter
    end

    View.class_eval do
      alias :initiator :viewer
    end

    Favorite.class_eval do
      alias :initiator :favorer
    end

    Following.class_eval do
      alias :initiator :follower
    end

    Watching.class_eval do
      alias :initiator :watcher
    end

    Events::Dispatcher.unsubscribe_all
    Events::Dispatcher.subscribe Activities::Feeder

    models = [Answer, Comment, Evaluation, Favorite, Following, Labeling, Question, View, Vote, Watching]
    date   = Question.order(:created_at).first.created_at

    until date > Time.now
      resources = models.map { |model| model.where('created_at >= ? AND created_at < ?', date, date + 1.month) }.flatten.compact

      resources.sort_by!(&:created_at)

      puts "Getting records (#{resources.count}) from #{date} ..."

      resources.each do |resource|
        Timecop.freeze(resource.created_at) do
          initiator = resource.initiator

          Events::Dispatcher.dispatch(:create, initiator, resource)
        end
      end

      date = date + 1.month
    end
  end
end
