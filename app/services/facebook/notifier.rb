module Facebook
  module Notifier
    extend self

    def publish(action, initiator, resource, options = {})
      notifications = options[:results][Notifications::Notifier] || fail

      return unless [Answer, Question, Comment].find { |type| resource.is_a? type }

      controller  = options.delete(:controller)
      application = FbGraph::Application.new(Configuration.facebook.application.id, secret: Configuration.facebook.application.secret)

      notifications.select { |notification| notification.recipient.omniauth_token }.each do |notification|
        FbGraph::User.me(notification.recipient.omniauth_token).fetch.notification!(
          access_token: application.get_access_token,
          href: controller.render_to_string(partial: 'facebook/notification_link', locals: { notification: notification }).strip,
          template: controller.render_to_string(partial: 'facebook/notification_content', locals: { notification: notification }).strip
        )
      end
    end
  end
end
