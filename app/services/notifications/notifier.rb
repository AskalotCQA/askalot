module Notifications
  module Notifier
    extend self

    attr_accessor :factory

    def publish(action, initiator, resource, options = {})
      target   = options[:on] || resource
      watchers = target.watchers - [initiator]

      watchers.each do |watcher|
        factory.create(action: action, initiator: initiator, recipient: watcher, notifiable: resource)
      end
    end

    def factory
      @factory ||= Notification
    end
  end
end
