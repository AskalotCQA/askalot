module University::Events
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
      results = options[:results] = {}

      listeners.each do |listener|
        results[listener] = listener.publish(action, initiator, resource, options.clone)
      end

      results
    end
  end
end
