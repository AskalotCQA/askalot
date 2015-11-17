# Order is important since a subscriber can pass results to following ones.

University::Events::Dispatcher.subscribe University::Activities::Feeder
University::Events::Dispatcher.subscribe University::Notifications::Notifier
University::Events::Dispatcher.subscribe University::Facebook::Notifier
University::Events::Dispatcher.subscribe University::Reputation::Notifier
