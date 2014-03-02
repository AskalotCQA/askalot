module Notifications
  module Notifier
    extend self

    attr_accessor :factory

    def publish(action, initiator, resource)
      resource.watchers.each do |watcher|
        factory.create(action: action, initiator: initiator, recipient: watcher, notifiable: resource)
      end
    end

    def factory
      @factory ||= Notification
    end
  end
end
