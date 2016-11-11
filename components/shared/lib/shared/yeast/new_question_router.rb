module Shared::Yeast
  module NewQuestionRouter
    extend self

    PYTHON_RETURN_FILE = '/media/dmacjam/Data disc1/git/Askalot-dev/askalot/recommendation/rec-users.dat'

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
        # puts to see the output
        `python scripts/python/QuestionRouterEnsemble.py #{resource.id} #{resource.answers.first
                                                                                     .try(:author).try(:id)}`
        File.open(PYTHON_RETURN_FILE, "r") do |f|
          f.each_line do |user_id|
            # Save recommendations
            #recommendation = Shared::Recommendation.create(question: resource, user_id: user_id)
            #recommendation.save

            # Send notification
            # TODO initiator_id ?
            Shared::Notification.create(recipient_id: user_id, initiator_id: 0,
                                        resource: resource,
                                        action: :create,
                                        anonymous: :true,
                                        context: Shared::Context::Manager.default_context_id)
          end
        end
      end

    end

  end
end
