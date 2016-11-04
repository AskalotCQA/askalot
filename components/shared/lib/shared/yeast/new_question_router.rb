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
        puts `python scripts/python/QuestionRouterEnsemble.py #{resource.id} #{resource.answers.first
                                                                                     .try(:author).try(:id)}`
      end

    end

  end
end
