module Shared::Activities
  module Feeder
    extend self

    def publish(action, initiator, resource, options = {})
      context = Shared::Context::Manager.current_context_id

      Shared::Activity.create!(action: action, initiator: initiator, resource: resource, anonymous: !!options[:anonymous], context: context) if Shared::Activity.column_names.include? 'context'
      Shared::Activity.create!(action: action, initiator: initiator, resource: resource, anonymous: !!options[:anonymous]) unless Shared::Activity.column_names.include? 'context'
    end
  end
end
