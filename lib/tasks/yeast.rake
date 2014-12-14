require 'yeast'
require_relative '../../app/services/events/dispatcher'

# rake yeast:feed FEEDERS=ExampleFeeder,MyAwesomeFeeder
#   NOTE feeders order MATTERS!

namespace :yeast do
  desc 'Prepare dispatcher'
  task feed: :environment do
    Events::Dispatcher.unsubscribe_all

    raise ArgumentError.new('You have to specify at least one feeder.') unless ENV['FEEDERS']

    feeders = ENV['FEEDERS'].split(',').map do |name|
      "Yeast::#{name}".constantize
    end

    feeders.each do |feeder|
      Events::Dispatcher.subscribe(feeder)
    end

    Yeast.run
  end
end
