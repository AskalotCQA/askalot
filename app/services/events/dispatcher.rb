module Events
  module Dispatcher
    extend self

    def listeners
      @listeners ||= []
    end

    def subscribe(listener)
      listeners << listener
    end

    def unsubscribe(listener)
      listeners.delete(listener)
    end

    def unsubscribe_all
      @listeners = []
    end

    def dispatch(action, initiator, resource, options = {})

      listeners.each do |listener|
        listener.publish(action, initiator, resource, options)
      end
    end
  end
end
