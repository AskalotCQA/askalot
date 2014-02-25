module Notifications
  module Service
    extend self

    def notifiers
      @notifiers ||= []
    end

    def subscribe(notifier)
      notifiers << notifier
    end

    def unsubscribe_all
      @notifiers = []
    end

    def notify(resource, initiator, event)
      notifiers.each do |notifier|
        notifier.publish(resource, initiator, event)
      end
    end
  end
end
