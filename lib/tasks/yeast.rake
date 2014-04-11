require 'yeast'
require_relative '../../app/services/events/dispatcher'

namespace :yeast do
  desc 'Prepare dispatcher'
  task feed: :environment do
    Events::Dispatcher.unsubscribe_all

    # TODO (smolnar) order: AF, QF, UF
    Events::Dispatcher.subscribe Yeast::AnswerFeeder
    Events::Dispatcher.subscribe Yeast::QuestionFeeder
    Events::Dispatcher.subscribe Yeast::UserFeeder

    # TODO (smolnar) consider View
    models    = [Question, Answer, Vote, Comment, Labeling]
    resources = models.map { |model| model.order(:created_at).first(1000) }.flatten

    until resources.empty?
      resources.sort_by!(&:created_at)

      resources.each do |resource|
        Timecop.freeze(resource.created_at) do
          initiator = case
                      when resource.respond_to?(:author) then resource.author
                      when resource.respond_to?(:viewer) then resource.viewer
                      when resource.respond_to?(:voter)  then resource.voter
                      else fail
                      end

          Events::Dispatcher.dispatch(:create, initiator, resource)
        end
      end

      resources = models.map { |model|
        resource = resources.select { |r| r.class == model }.last

        next unless resource

        model.order(:created_at).where('created_at > ?', resource.created_at).first(1000)
      }.flatten.compact
    end
  end
end
