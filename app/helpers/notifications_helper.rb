module NotificationsHelper
  def notification_icon_tag(notification, options = {})
    data    = notification_data notification
    color   = notification.unread ? data[:color][:action] : :'text-muted'
    type    = notification.action == :mention ? :mention : :persistence
    title   = t "notification.icon.#{type}", action: t("notification.action.#{notification.action}"), resource: t("notification.content.#{type}.#{notification.notifiable.class.name.downcase}")
    options = options.merge(tooltip_attributes title, placement: :bottom)

    icon_tag data[:icon][:resource], options.merge(class: color, fixed: true)
  end

  def notification_content(notification, options = {})
    notifiable = notification.notifiable

    content = case notifiable.class.name.downcase.to_sym
    when :comment then "notification.content.#{notifiable.class.name.downcase}.#{notifiable.commentable.class.name.downcase}.#{notification.action}"
    when :evaluation then "notification.content.#{notifiable.class.name.downcase}.#{notifiable.evaluable.class.name.downcase}.#{notification.action}"
    else "notification.content.#{notifiable.class.name.downcase}.#{notification.action}"
    end

    body = t("notification.content.#{notification.action == :mention ? :mention : :persistence}.#{notifiable.class.name.downcase}")

    resource = link_to_notifiable notifiable, body: body
    question = link_to_notifiable notifiable, length: 50
    content  = t(content, resource: resource, question: question).html_safe

    notification.unread ? content : content_tag(:span, content, class: :'text-muted')
  end

  def link_to_notifiable(notifiable, options = {})
    case notifiable.class.name.downcase.to_sym
    when :answer     then link_to_answer notifiable, options
    when :comment    then link_to_comment notifiable, options
    when :evaluation then link_to_evaluation notifiable, options
    when :favorite   then link_to_question notifiable.question, options
    when :labeling   then link_to_question notifiable.answer.question, options
    when :question   then link_to_question notifiable, options
    when :view       then link_to_question notifiable.question, options
    when :vote       then link_to_question notifiable.votable.to_question, options
    else fail
    end
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
    when :answer     then color[:resource], icon[:resource] = :'text-info',    :'exclamation-circle'
    when :comment    then color[:resource], icon[:resource] = :'text-warning', :comments
    when :evaluation then color[:resource], icon[:resource] = :'text-warning', :magic
    when :favorite   then color[:resource], icon[:resource] = :'text-warning', :star
    when :labeling   then color[:resource], icon[:resource] = :'text-success', :check
    when :question   then color[:resource], icon[:resource] = :'text-primary', :'question-circle'
    when :view       then color[:resource], icon[:resource] = :'text-muted',   :eye
    when :vote       then color[:resource], icon[:resource] = :'text-muted',   :sort
    end

    { color: color, icon: icon }
  end
end
