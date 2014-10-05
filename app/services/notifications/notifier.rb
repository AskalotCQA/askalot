module Notifications
  module Notifier
    extend self

    attr_accessor :factory


    def publish(action, initiator, resource, options = {})
      recipients = (Array.wrap(options[:for] || resource.watchers) - [initiator]).uniq

      recipients.each do |recipient|
        message =  factory.create!(action: action, initiator: initiator, recipient: recipient, resource: resource, anonymous: !!options[:anonymous])

        if message.resource.is_a?(Answer || Question || Comment)
          if recipient.oauth_token
            user = FbGraph::User.me(recipient.oauth_token).fetch
            app = FbGraph::Application.new('308609915963601', :secret => '2c38cdee881763cedffe006d86a73c39')

            user.notification!(
              :access_token => app.get_access_token,
              :href => 'http://askalot.fiit.stuba.sk',
              :template => 'Askalot need your attention'
            )
          end
        end
      end
    end

    def factory
      @factory ||= Notification
    end
  end
end
