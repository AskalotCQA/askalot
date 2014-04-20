module Activities
  module Feeder
    extend self

    def publish(action, initiator, resource, options = {})
      Activity.create!(action: action, initiator: initiator, resource: resource)
    end
  end
end
