module NotificationsHelper
  def notification_icon_tag(notification, options = {})
    data = notification_data notification

    icon_tag data[:icon], class: data[:color], fixed: true
  end

  private

  def notification_data(notification)
    case notification.action.to_s
    when /create/  then { color: :'text-success', icon: :check }
    when /update/  then { color: :'text-info',    icon: :pencil }
    when /delete/  then { color: :'text-danger',  icon: :times }
    when /mention/ then { color: :'text-warning', icon: :bolt }
    end
  end
end
