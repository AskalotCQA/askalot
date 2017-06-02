module Shared
  class DispatchedEventHandlerJob < ActiveJob::Base
    queue_as :default

    def perform(action, initiator, resource, options)
      options[:for]        = Shared::User.where(id: options[:for]) if options[:for]
      options[:controller] = options[:controller].constantize

      Shared::Events::Dispatcher.dispatch(action.to_sym, initiator, resource, options)
    end
  end
end
