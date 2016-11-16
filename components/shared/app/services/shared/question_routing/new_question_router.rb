module Shared::QuestionRouting
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

      #puts "Feeding for #{action} '#{action}' on #{resource} by #{initiator.try(:nick) || 'no one'} ..."

      if resource.is_a? Shared::Question
        Thread.new do
          # puts to see the output
          users_ids = `python scripts/python/QuestionRouterEnsemble.py #{resource.id} 2>> recommendation/qrouting-error.log`
          #puts `python scripts/python/QuestionRouterEnsemble.py #{resource.id} #{resource.answers.first
          #                                                                             .try(:author).try(:id)}`

          users_ids = users_ids.split("\n")
          users_ids.each do |user_id|
            # Save recommendations
            #recommendation = Shared::Recommendation.create(question: resource, user_id: user_id)
            #recommendation.save

            # Send notification
            # TODO initiator_id ?
            Shared::Notification.create(recipient_id: user_id, initiator_id: 0,
                                        resource: resource,
                                        action: :recommendation,
                                        anonymous: true,
                                        context: Shared::Context::Manager.current_context_id)
          end
          ActiveRecord::Base.connection.close
        end
      end
    end

  end
end
