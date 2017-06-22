module Shared::NotificationsHelper
  def notification_icon_tag(notification, options = {})
    activity_icon_tag notification, notification_options(notification, options)
  end

  def notification_content(notification, options = {})
    activity_content notification, notification_options(notification, options)
  end

  def notification_content_by_attributes(action, initiator, resource, options = {})
    activity_content_by_attributes(action, initiator, resource, options)
  end

  def link_to_notification(notification, options = {}, &block)
    link_to_activity notification, options, &block
  end

  def link_to_notification_by_attributes(action, initiator, resource, options = {}, &block)
    link_to_activity_by_attributes action, initiator, resource, options, &block
  end

  def link_to_notifications(notifications, options = {})
    count = notifications.unread.unscope(:limit, :offset).size
    body  = options.delete(:body) || t('notification.unread_x', count: count)
    url   = options.delete(:url)  || shared.notifications_path

    link_to body, url, analytics_attributes(:notifications, :list, "#{count}-unread").deep_merge(options)
  end

  private

  def notification_options(notification, options = {})
    options[:mute] = lambda { |_| !notification.unread }
    options[:url]  = lambda { |url| notification.unread ? (options[:absolute_url] ? shared.read_notification_url(notification, params: { r: url }) : shared.read_notification_path(notification, params: { r: url })) : url }
    options
  end
end
