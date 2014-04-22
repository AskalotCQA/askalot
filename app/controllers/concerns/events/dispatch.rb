module Events::Dispatch
  extend ActiveSupport::Concern

  def dispatch_event(action, resource, initiator: current_user, **options)
    Events::Dispatcher.dispatch(action, initiator, resource, options)
  end

  def dispatch_event_action_for(resource)
    return :delete if resource.destroyed? || (resource.is_a?(Deletable) && resource.deleted?)

    resource.changed? ? :update : :create
  end
end
