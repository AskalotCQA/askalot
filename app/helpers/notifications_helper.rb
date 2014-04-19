module NotificationsHelper
  def notification_icon_tag(notification, options = {})
    activity_icon_tag notification, notification_options(notification, options)
  end

  def notification_content(notification, options = {})
    activity_content notification, notification_options(notification, options)
  end

  def link_to_notification(notification, options = {}, &block)
    link_to_activity notification, notification_options(notification, options), &block
  end

  private

  def notification_options(notification, options = {})
    options[:mute] = lambda { |_| !notification.unread }
    options[:url]  = lambda { |url| notification.unread ? read_notification_path(notification, params: { r: url }) : url }
    options
  end
end
