require './scripts/extract_features'
require './scripts/offline_features_manager'

module Shared::Yeast
  module NewQuestionRouter
    extend self

    # get new question, compute user probabilites, route new questions
    # question - preprocess and create BOW
    # filter users
    # users - load profile BOW
    #       - compute prior features
    # compute probabilities of users given question
    # send notifications

    def publish(action, initiator, resource, options = {})
      return unless action == :create

      puts "Feeding for #{action} '#{action}' on #{resource} by #{initiator.try(:nick) || 'no one'} ..."

      if resource.is_a? Shared::Question
        #`python scripts/python/NewQuestionRouter.py #{resource.id}`
      end

      if resource.is_a? Shared::Answer
        `python scripts/python/UpdateUserProfile.py #{resource.id}`
      end
    end

  end
end
