module Shared::Facebook
  module Notifier
    extend self

    def publish(action, initiator, resource, options = {})
      notifications = options[:results][Shared::Notifications::Notifier] || fail

      return unless action == :create
      return unless [Shared::Answer, Shared::Question, Shared::Comment, Shared::Evaluation, Shared::Label].find { |type| resource.is_a? type }

      controller  = options.delete(:controller)
      application = FbGraph2::Auth.new(Shared::Configuration.facebook.application.id, Shared::Configuration.facebook.application.secret)

      notifications.select { |notification| has_token_and_wants_notifications(notification.recipient) }.each do |notification|
        content          = ActionView::Base.full_sanitizer.sanitize(controller.render_to_string(partial: 'shared/facebook/notification_content', locals: { notification: notification }))
        link             = controller.render_to_string(partial: 'shared/facebook/notification_link', locals: { notification: notification, content: content }).strip
        token            = notification.recipient.omniauth_token
        token_validation = application.debug_token! token

        next unless token_validation.is_valid

        link = link.gsub('&amp;', '&')

        begin
          FbGraph2::User.me(token).fetch.notification! access_token: application.access_token!, href: link, template: content
        rescue FbGraph2::Exception::InvalidRequest
          nil
        end
      end
    end

    def has_token_and_wants_notifications(recipient)
      recipient.omniauth_token && recipient.send_facebook_notifications
    end
  end
end
