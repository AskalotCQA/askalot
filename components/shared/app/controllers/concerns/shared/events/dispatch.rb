module Shared::Events::Dispatch
  extend ActiveSupport::Concern

  def dispatch_event(action, resource, initiator: current_user, **options)
    Shared::Events::Dispatcher.dispatch(action, initiator, resource, options.merge(controller: self))
  end

  def dispatch_event_action_for(resource)
    return :delete if resource.destroyed? || (resource.is_a?(Shared::Deletable) && resource.deleted?)

    resource.changed? ? :update : :create
  end
end
