module NotificationsHelper
  def notification_icon_tag(notification, options = {})
    data    = notification_data notification
    options = options.merge(tooltip_attributes t("notification.action.#{notification.action}"), placement: :bottom)

    icon_tag data[:icon][:action], options.merge(class: data[:color][:action], fixed: true)
  end

  private

  def notification_data(notification)
    color, icon = {}, {}

    case notification.action
    when :create  then color[:action], icon[:action] = :'text-success', :check
    when :update  then color[:action], icon[:action] = :'text-info',    :pencil
    when :delete  then color[:action], icon[:action] = :'text-danger',  :times
    when :mention then color[:action], icon[:action] = :'text-warning', :bolt
    end

    case notification.notifiable.class.name.downcase.to_sym
    when :answer   then color[:resource], icon[:resource] = :'text-info',    :exclamation
    when :comment  then color[:resource], icon[:resource] = :'text-warning', :comment
    when :favorite then color[:resource], icon[:resource] = :'text-warning', :star
    when :labeling then color[:resource], icon[:resource] = :'text-success', :check
    when :question then color[:resource], icon[:resource] = :'text-primary', :question
    when :view     then color[:resource], icon[:resource] = :'text-muted',   :eye
    when :vote     then color[:resource], icon[:resource] = :'text-muted',   :sort
    end

    { color: color, icon: icon }
  end
end
