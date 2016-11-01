require 'shared/yeast/example_feeder'
require 'shared/yeast/new_question_router'
require 'shared/yeast/features_weights_updater'

module Shared::Yeast
  def self.run
    [Shared::Question, Shared::Answer, Shared::Comment, Shared::Labeling].each do |model|
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

    Shared::List.class_eval do
      alias :initiator :lister
    end

    Shared::User.class_eval do
      # TODO initiator self?
      alias :initiator :role
    end

    interval = 1.hour

    # TODO (smolnar) consider View
    models = [Shared::Question, Shared::Answer, Shared::Vote, Shared::Comment,
              Shared::View, Shared::List, Shared::User]
    date   = Shared::Question.order(:created_at).first.created_at

    until date > Time.now
      resources = models.map { |model| model.where('created_at >= ? AND created_at < ?', date, date + interval) }.flatten.compact

      resources.sort_by!(&:created_at)

      puts "Getting records (#{resources.count}) from #{date} ..."

      resources.each do |resource|
        Timecop.freeze(resource.created_at) do
          initiator = resource.initiator

          Shared::Events::Dispatcher.dispatch(:create, initiator, resource)
        end
      end

      date = date + interval
    end
  end
end
