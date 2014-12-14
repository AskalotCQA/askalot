module Yeast
  module ExampleFeeder
    extend self

    def publish(action, initiator, resource, options = {})
      puts "Feeding for #{action} '#{action}' on #{resource} by #{initiator.try(:nick) || 'no one'} ..."
    end
  end
end
