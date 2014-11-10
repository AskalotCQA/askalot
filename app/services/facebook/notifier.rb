module Facebook
  module Notifier
    extend self

    def publish(action, initiator, resource, options = {})
      return unless [Answer, Question, Comment].find { |type| resource.is_a? type }

      controller  = options.delete(:controller)
      application = FbGraph::Application.new(Configuration.facebook.application.id, secret: Configuration.facebook.application.secret)

      attributes = { action: action, initiator: initiator, resource: resource }
      recipients = (Array.wrap(options[:for] || resource.watchers) - [initiator]).uniq

      recipients.select { |recipient| recipient.omniauth_token }.each do |recipient|
        user = FbGraph::User.me(recipient.omniauth_token).fetch

        user.notification!(
          access_token: application.get_access_token,
          href: Configuration.facebook.application.link,
          template: controller.render_to_string(partial: 'facebook/notification_content', locals: attributes).strip
        )
      end
    end
  end
end
