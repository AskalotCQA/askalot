# Order is important since a subscriber can pass results to following ones.

Shared::Events::Dispatcher.subscribe Shared::Activities::Feeder
Shared::Events::Dispatcher.subscribe Shared::Notifications::Notifier
Shared::Events::Dispatcher.subscribe Shared::Facebook::Notifier
Shared::Events::Dispatcher.subscribe Shared::Reputation::Notifier
Shared::Events::Dispatcher.subscribe Shared::QuestionRouting::NewQuestionRouter
Shared::Events::Dispatcher.subscribe Shared::QuestionRouting::FeaturesWeightsUpdater
