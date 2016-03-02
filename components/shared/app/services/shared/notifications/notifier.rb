module Shared::Notifications
  module Notifier
    extend self

    attr_accessor :factory

    def publish(action, initiator, resource, options = {})
      recipients = (Array.wrap(options[:for] || resource.watchers) - [initiator]).uniq
      context = Shared::Context::Manager.current_context
      notifications = []

      recipients.each do |recipient|
        notifications << factory.create!(action: action, initiator: initiator, recipient: recipient, resource: resource, anonymous: !!options[:anonymous], context: context)
      end

      notifications
    end

    def factory
      @factory ||= Shared::Notification
    end
  end
end
