module Yeast
  module UserFeeder
    extend self

    def publish(action, initiator, resource, options = {})
      return unless action == :create

      question = nil

      question = resource if resource.class == Question
      question = resource.votable if resource.class == Vote && resource.votable.class == Question
      question = resource.quesiton if resource.class == Favorite

      if resource.class == Question
        question.tags.each do |tag|
          profile = User::Profile.find_or_create_by! targetable: tag, user: question.author, property: :interest, source: :QE

          profile.update_attributes!(value: 0.5, probability: 0)
        end
      end

      if question
        question.tags.each do |tag|
          profile = User::Profile.find_or_create_by! targetable: tag, user: question.author, property: :interest, source: :QE

          value = question.profiles.as(:QE).for(:quality).first.value + profile.value

          profile.update_attributes!(value: value)
        end
      end
    end
  end
end
