module Shared::Notifications
  module Notifier
    extend self

    attr_accessor :factory

    def publish(action, initiator, resource, options = {})
      return if action == :update && too_new_since_resource_creation?(resource) || too_new_since_last_notification?(resource)

      recipients = (Array.wrap(options[:for] || resource.watchers) - [initiator]).uniq
      context = Shared::Context::Manager.current_context_id
      notifications = []

      recipients.each do |recipient|
        next if recipient.alumni?

        notifications << factory.create!(action: action, initiator: initiator, recipient: recipient, resource: resource, anonymous: !!options[:anonymous], context: context) if Shared::Notification.column_names.include? 'context'
        notifications << factory.create!(action: action, initiator: initiator, recipient: recipient, resource: resource, anonymous: !!options[:anonymous]) unless Shared::Notification.column_names.include? 'context'
      end

      notifications
    end

    def factory
      @factory ||= Shared::Notification
    end

    private

    def too_new_since_resource_creation?(resource)
      (Time.current - resource.created_at) < 300 # 300 seconds
    end

    def too_new_since_last_notification?(resource)
      last_notification = resource.notifications.where(action: :update).order(created_at: :desc).first

      return false if last_notification.nil?

      (Time.current - last_notification.created_at) < 60
    end
  end
end
