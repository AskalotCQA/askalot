require 'yeast'
require_relative '../../components/university/app/services/university/events/dispatcher'

# rake yeast:feed FEEDERS=ExampleFeeder,MyAwesomeFeeder
#   NOTE feeders order MATTERS!

namespace :yeast do
  desc 'Prepare dispatcher'
  task feed: :environment do
    University::Events::Dispatcher.unsubscribe_all

    raise ArgumentError.new('You have to specify at least one feeder.') unless ENV['FEEDERS']

    feeders = ENV['FEEDERS'].split(',').map do |name|
      "Yeast::#{name}".constantize
    end

    feeders.each do |feeder|
      University::Events::Dispatcher.subscribe(feeder)
    end

    Yeast.run
  end
end
