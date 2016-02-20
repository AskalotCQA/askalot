module Shared::Activities
  module Feeder
    extend self

    def publish(action, initiator, resource, options = {})
      context = Shared::ApplicationHelper.current_context

      Shared::Activity.create!(action: action, initiator: initiator, resource: resource, anonymous: !!options[:anonymous], context: context)
    end
  end
end
