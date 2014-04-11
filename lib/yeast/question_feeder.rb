module Yeast
  module QuestionFeeder
    extend self

    def publish(action, initiator, resource, options = {})
      return unless action == :create

      if resource.class == Question
        profile = Question::Profile.find_or_create_by! question: resource, property: :quality, source: :QE

        profile.update_attributes!(value: 0.5, probability: 0)
      end

      if resource.class == Vote && resource.votable.class == Question
        question = resource.votable

        profile = Question::Profile.find_or_create_by! question: question, property: :quality, source: :QE

        value = 1 / (1 + Math::E**-(resource.votable.votes.positive.size - resource.votable.votes.negative.size)) + (question.favorites.size * 0.1)

        profile.update_attributes!(value: value)
      end

      if resource.class == Favorite
        question = resource.question

        profile = Question::Profile.find_or_create_by! question: question, property: :quality, source: :QE

        profile.update_attributes!(value: profile.value + 0.1)
      end
    end
  end
end
