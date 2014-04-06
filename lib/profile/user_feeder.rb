module Profile
  module UserFeeder
    extend self

    def publish(action, initiator, resource, options = {})
      # TODO
      puts "Recieved '#{action}' from #{initiator.name} on #{resource} at #{Time.now}"
    end
  end
end
