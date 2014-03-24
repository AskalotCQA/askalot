module Notifications
  module Notifier
    extend self

    attr_accessor :factory

    def publish(action, initiator, resource, options = {})
      recipients = (Array.wrap(options[:for] || resource.watchers) - [initiator]).uniq

      recipients.each do |recipient|
        factory.create!(action: action, initiator: initiator, recipient: recipient, resource: resource)
      end
    end

    def factory
      @factory ||= Notification
    end
  end
end
