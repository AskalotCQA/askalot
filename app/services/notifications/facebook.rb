module Notifications
  module Notifier include ActivitiesHelper
  extend self

  attr_accessor :factory

  def publish(action, initiator, resource, options = {})
    recipients = (Array.wrap(options[:for] || resource.watchers) - [initiator]).uniq

    recipients.each do |recipient|
      message =  factory.create!(action: action, initiator: initiator, recipient: recipient, resource: resource, anonymous: !!options[:anonymous])

      if message.resource.is_a?(Answer || Question || Comment)
        if recipient.oauth_token
          user = FbGraph::User.me(recipient.oauth_token).fetch
          app = FbGraph::Application.new('308609915963601', secret: '9d4459184d7a61afec6d216eda49f69d')

          user.notification!(
            access_token: app.get_access_token,
            href: 'http://askalot.fiit.stuba.sk',
            template: activity_content(message)
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
