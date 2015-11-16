module University::Events::Dispatch
  extend ActiveSupport::Concern

  def dispatch_event(action, resource, initiator: current_user, **options)
    University::Events::Dispatcher.dispatch(action, initiator, resource, options.merge(controller: self))
  end

  def dispatch_event_action_for(resource)
    return :delete if resource.destroyed? || (resource.is_a?(University::Deletable) && resource.deleted?)

    resource.changed? ? :update : :create
  end
end
