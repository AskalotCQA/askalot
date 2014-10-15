module Notifications
  module Notifier
    extend self
    
    include NotificationsHelper
  # TODO include any additionals helpers here

    attr_accessor :factory
  
    def publish(action, initiator, resource, options = {})
      recipients = (Array.wrap(options[:for] || resource.watchers) - [initiator]).uniq
  
      recipients.each do |recipient|
        message = factory.create!(action: action, initiator: initiator, recipient: recipient, resource: resource, anonymous: !!options[:anonymous])
  
        # TODO bla bla bla & refactor
  
        if message.resource.is_a?(Answer || Question || Comment)
          if recipient.oauth_token
            user = FbGraph::User.me(recipient.oauth_token).fetch
            app = FbGraph::Application.new('308609915963601', secret: '9d4459184d7a61afec6d216eda49f69d')
  
            user.notification!(
              access_token: app.get_access_token,
              href: 'http://askalot.fiit.stuba.sk',
              template: notification_content_by_resource(resource, unlink: true) # TODO use this and only this here
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
