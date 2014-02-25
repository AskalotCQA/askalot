module Notifications
  module Service
    extend self

    def notifiers
      @notifiers ||= []
    end

    def subscribe(notifier)
      notifiers << notifier
    end

    def unsubscribe(notifier)
      notifiers.delete(notifier)
    end

    def unsubscribe_all
      @notifiers = []
    end

    def notify(action, initiator, resource)
      notifiers.each do |notifier|
        notifier.publish(action, initiator, resource)
      end
    end
  end
end
