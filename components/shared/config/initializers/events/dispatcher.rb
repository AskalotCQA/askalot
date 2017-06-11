# Order is important since a subscriber can pass results to following ones.

Shared::Events::Dispatcher.subscribe Shared::Activities::Feeder
Shared::Events::Dispatcher.subscribe Shared::Notifications::Notifier
Shared::Events::Dispatcher.subscribe Shared::Facebook::Notifier if Shared::Configuration.facebook.enabled
Shared::Events::Dispatcher.subscribe Shared::Reputation::Notifier if Rails.module.university?
