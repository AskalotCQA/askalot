module Shared::Activities
  module Feeder
    extend self

    def publish(action, initiator, resource, options = {})
      context = Shared::Context::Manager.current_context
      attributes = {
        action: action,
        initiator: initiator,
        resource: resource,
        anonymous: !!options[:anonymous],
        context: context
      }
      activity = Shared::Activity.new
      activity.attributes = attributes.reject { |k, _| !Shared::Category.column_names.include? k.to_s }

      activity.save
    end
  end
end
