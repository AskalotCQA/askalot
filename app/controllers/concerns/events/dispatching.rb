module Events::Dispatching
  extend ActiveSupport::Concern

  def dispatch_event(action, resource, initiator: current_user, **options)
    Events::Dispatcher.dispatch(action, initiator, resource, options)
  end

  def dispatch_event_action_for(resource)
    resource.destroyed? ? :delete : (resource.changed? ? :update : :create)
  end
end
