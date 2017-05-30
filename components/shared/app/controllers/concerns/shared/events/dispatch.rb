module Shared::Events::Dispatch
  extend ActiveSupport::Concern

  def dispatch_event(action, resource, initiator: current_user, **options)
    # please note that if you add new options you may need to perform data manipulation such as this:
    options[:for] = Array.wrap(options[:for]).map(&:id) if options[:for]

    Shared::DispatchedEventHandlerJob.perform_later(action.to_s, initiator, resource, options.merge(controller: self.class.name))
  end

  def dispatch_event_action_for(resource)
    return :delete if resource.destroyed? || (resource.is_a?(Shared::Deletable) && resource.deleted?)

    resource.changed? ? :update : :create
  end
end
