require 'yeast/example_feeder'

module Yeast
  def self.run
    [Question, Answer, Comment, Labeling].each do |model|
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

    interval = 1.hour

    # TODO (smolnar) consider View
    models = [Question, Answer, Vote, Comment, Labeling]
    date   = Question.order(:created_at).first.created_at

    until date > Time.now
      resources = models.map { |model| model.where('created_at >= ? AND created_at < ?', date, date + interval) }.flatten.compact

      resources.sort_by!(&:created_at)

      puts "Getting records (#{resources.count}) from #{date} ..."

      resources.each do |resource|
        Timecop.freeze(resource.created_at) do
          initiator = resource.initiator

          Events::Dispatcher.dispatch(:create, initiator, resource)
        end
      end

      date = date + interval
    end
  end
end
