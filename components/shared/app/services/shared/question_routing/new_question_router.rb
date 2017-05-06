module Shared::QuestionRouting
  module NewQuestionRouter
    extend self

    def publish(action, initiator, resource, options = {})
      return unless action == :create

      if resource.is_a? Shared::Question
        Thread.new do
          # puts to see the output
          `python scripts/python/UpdateQuestion.py #{resource.id} >> recommendation/update-profile.log 2>&1`
          users_ids = `python scripts/python/QuestionRouterEnsemble.py #{resource.id} 2>> recommendation/qrouting-error.log`
          #puts `python scripts/python/QuestionRoutingEvaluation.py #{resource.id} #{resource.answers.first
          #                                                                             .try(:author).try(:id)}`

          users_ids = users_ids.split("\n")
          users_ids.each do |user_id|
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
