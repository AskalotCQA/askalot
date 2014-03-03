module Concerns::Notifying
  def notify_watchers_about(action, initiator: current_user, **options)
    resource = options[:on]

    Notifications::Dispatcher.notify(action, initiator, resource)
  end
end
