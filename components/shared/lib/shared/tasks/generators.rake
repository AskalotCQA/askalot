require_relative '../../components/shared/app/services/shared/events/dispatcher'

namespace :generators do
  desc 'Generate activities'
  task activities: :environment do
    [Shared::Question, Shared::Answer, Shared::Comment, Shared::Labeling, Shared::Evaluation, Shared::Tagging].each do |model|
      model.class_eval do
        alias :initiator :author
      end
    end

    Shared::Vote.class_eval do
      alias :initiator :voter
    end

    Shared::View.class_eval do
      alias :initiator :viewer
    end

    Shared::Favorite.class_eval do
      alias :initiator :favorer
    end

    Shared::Following.class_eval do
      alias :initiator :follower
    end

    Shared::Watching.class_eval do
      alias :initiator :watcher
    end

    Shared::Events::Dispatcher.unsubscribe_all
    Shared::Events::Dispatcher.subscribe Activities::Feeder

    models = [Shared::Answer, Shared::Comment, Shared::Evaluation, Shared::Favorite, Shared::Following, Shared::Labeling, Shared::Question, Shared::Tagging, Shared::View, Shared::Vote, Shared::Watching]
    date   = Shared::Question.order(:created_at).first.created_at

    until date > Time.now
      resources = models.map { |model| model.where('created_at >= ? AND created_at < ?', date, date + 1.month) }.flatten.compact

      resources.sort_by!(&:created_at)

      puts "Getting records (#{resources.count}) from #{date} ..."

      resources.each do |resource|
        Timecop.freeze(resource.created_at) do
          initiator = resource.initiator

          Shared::Events::Dispatcher.dispatch(:create, initiator, resource)
        end
      end

      date = date + 1.month
    end

    Activity.find_each do |activity|
      activity.update_attributes!(anonymous: true) if activity.resource.class == Shared::Question && activity.resource.anonymous == true
    end
  end
end
