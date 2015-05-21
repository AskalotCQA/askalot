# Order is important since a subscriber can pass results to following ones.

Events::Dispatcher.subscribe Activities::Feeder
Events::Dispatcher.subscribe Notifications::Notifier
Events::Dispatcher.subscribe Facebook::Notifier
Events::Dispatcher.subscribe Reputation::Notifier
