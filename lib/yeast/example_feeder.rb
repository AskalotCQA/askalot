module Yeast
  module ExampleFeeder
    extend self

    def publish(action, initiator, resource, options = {})
      return unless action == :create

      if resource.class == Question
        profile = Question::Profile.find_or_create_by!(question: resource, property: :quality, source: :QE)

        profile.update_attributes!(value: 0.5, probability: 0)
      end
    end
  end
end
