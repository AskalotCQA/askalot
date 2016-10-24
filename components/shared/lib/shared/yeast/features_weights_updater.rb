module Shared::Yeast
  module FeaturesWeightsUpdater
    extend self

    # recompute features weights based on linear regression

    def publish(action, initiator, resource, options = {})
      puts "Feeding for #{action} '#{action}' on #{resource} by #{initiator.try(:nick) || 'no one'} ..."
      resource.tex

      if resource.is_a? Shared::Answer
        # TODO update user features table
        resource.author.profiles.
            find_or_initialize_by(targetable_id: 3, targetable_type: 'answers_week', property: 'answers_week')
            .update(value: 3)
        #puts `python scripts/python/UpdateUserProfile.py #{resource.id}`
      end



    end

  end
end
