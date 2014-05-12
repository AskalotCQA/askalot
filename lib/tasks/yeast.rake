require 'yeast'
require_relative '../../app/services/events/dispatcher'

namespace :yeast do
  desc 'Prepare dispatcher'
  task feed: :environment do
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

    Events::Dispatcher.unsubscribe_all

    # TODO (smolnar) order matters: AF, QF, UF
    Events::Dispatcher.subscribe Yeast::AnswerFeeder
    Events::Dispatcher.subscribe Yeast::QuestionFeeder
    Events::Dispatcher.subscribe Yeast::UserFeeder
    Events::Dispatcher.subscribe Yeast::EvaluationFeeder

    # TODO (smolnar) consider View
    models = [Question, Answer, Vote, Comment, Labeling]
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
