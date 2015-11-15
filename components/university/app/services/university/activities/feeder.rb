module University::Activities
  module Feeder
    extend self

    def publish(action, initiator, resource, options = {})
      Activity.create!(action: action, initiator: initiator, resource: resource, anonymous: !!options[:anonymous])
    end
  end
end
