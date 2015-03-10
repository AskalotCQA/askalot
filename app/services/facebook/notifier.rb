module Facebook
  module Notifier
    extend self

    def publish(action, initiator, resource, options = {})
      notifications = options[:results][Notifications::Notifier] || fail

      return unless [Answer, Question, Comment, Evaluation, Label].find { |type| resource.is_a? type }

      controller  = options.delete(:controller)
      application = FbGraph::Application.new(Configuration.facebook.application.id, secret: Configuration.facebook.application.secret)

      notifications.select { |notification| notification.recipient.omniauth_token }.each do |notification|
        content          = controller.render_to_string(partial: 'facebook/notification_content', locals: { notification: notification }).strip
        link             = controller.render_to_string(partial: 'facebook/notification_link', locals: { notification: notification, content: content }).strip
        token            = notification.recipient.omniauth_token
        token_validation = application.debug_token token

        next unless token_validation.is_valid

        FbGraph::User.me(token).fetch.notification! access_token: application.get_access_token, href: link, template: content
      end
    end
  end
end
