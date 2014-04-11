module Yeast
  module AnswerFeeder
    extend self

    def publish(action, initiator, resource, options = {})
      return unless action == :create

      if resource.class == Answer
        profile = Answer::Profile.find_or_create_by! answer: resource, property: :quality, source: :QE

        profile.update_attributes!(value: 0.5, probability: 0)
      end

      if resource.class == Vote && resource.votable.class == Answer
        answer = resource.votable

        profile = Answer::Profile.find_or_create_by! answer: answer, property: :quality, source: :QE

        value = 1 / (1 + Math::E**-(resource.votable.votes.positive.size - resource.votable.votes.negative.size)) + (answer.best? ? 0.5 : 0)

        profile.update_attributes!(value: value)
      end

      if resource.class == Labeling
        answer = resource.answer

        profile = Answer::Profile.find_or_create_by! answer: answer, property: :quality, source: :QE

        value = profile.value + (answer.best? ? 0.5 : 0)

        profile.update_attributes!(value: value)
      end
    end
  end
end
