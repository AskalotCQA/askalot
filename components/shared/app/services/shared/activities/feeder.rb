module Shared::Activities
  module Feeder
    extend self

    def publish(action, initiator, resource, options = {})
      Shared::Activity.create!(action: action, initiator: initiator, resource: resource, anonymous: !!options[:anonymous])
    end
  end
end
