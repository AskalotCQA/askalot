require 'shared/yeast'
require_relative '../../app/services/shared/events/dispatcher'

# rake yeast:feed FEEDERS=ExampleFeeder,MyAwesomeFeeder
#   NOTE feeders order MATTERS!

namespace :yeast do
  desc 'Prepare dispatcher'
  task feed: :environment do
    Shared::Events::Dispatcher.unsubscribe_all

    raise ArgumentError.new('You have to specify at least one feeder.') unless ENV['FEEDERS']

    feeders = ENV['FEEDERS'].split(',').map do |name|
      "Shared::Yeast::#{name}".constantize
    end

    feeders.each do |feeder|
      Shared::Events::Dispatcher.subscribe(feeder)
    end

    Shared::Yeast.run
  end
end
