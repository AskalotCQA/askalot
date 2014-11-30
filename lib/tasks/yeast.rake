require 'yeast'
require_relative '../../app/services/events/dispatcher'

namespace :yeast do
  desc 'Prepare dispatcher'
  task feed: :environment do
    Events::Dispatcher.unsubscribe_all

    # TODO (smolnar) order matters: AF, QF, UF
    Events::Dispatcher.subscribe Yeast::AnswerFeeder
    Events::Dispatcher.subscribe Yeast::QuestionFeeder
    Events::Dispatcher.subscribe Yeast::UserFeeder

    Yeast.run
  end
end
