module NotificationsHelper
  def notification_icon_tag(notification, options = {})
    data    = notification_data notification
    color   = notification.unread ? data[:color][:action] : :'text-muted'
    type    = notification.action == :mention ? :mention : :persistence
    title   = t "notification.icon.#{type}", action: t("notification.action.#{notification.action}"), resource: t("notification.content.#{type}.#{notification.resource.class.name.downcase}")
    options = options.merge(tooltip_attributes title, placement: :bottom)

    icon_tag data[:icon][:resource], options.merge(class: color, fixed: true)
  end

  def notification_content(notification, options = {})
    resource = notification.resource

    content = case resource.class.name.downcase.to_sym
              when :comment then "notification.content.#{resource.class.name.downcase}.#{resource.commentable.class.name.downcase}.#{notification.action}"
              when :evaluation then "notification.content.#{resource.class.name.downcase}.#{resource.evaluable.class.name.downcase}.#{notification.action}"
              else "notification.content.#{resource.class.name.downcase}.#{notification.action}"
              end

    body    = t("notification.content.#{notification.action == :mention ? :mention : :persistence}.#{resource.class.name.downcase}")
    content = t(content, resource: link_to_notification(notification, body: body), question: link_to_notification(notification, length: 50)).html_safe

    notification.unread ? content : content_tag(:span, content, class: :'text-muted')
  end

  def link_to_notification(notification, options = {}, &block)
    options[:body] = capture(&block) if block_given?
    options[:path] = lambda { |path| notification.unread ? read_notification_path(notification, params: { r: path }) : path } if options.delete(:read) != false

    resource = notification.resource

    # TODO(zbell) add specific link_to_* helpers for all cases
    case resource.class.name.downcase.to_sym
    when :answer     then link_to_answer resource, options
    when :comment    then link_to_comment resource, options
    when :evaluation then link_to_evaluation resource, options
    when :favorite   then link_to_question resource.question, options
    when :following  then fail
    when :labeling   then link_to_question resource.answer.question, options
    when :question   then link_to_question resource, options
    when :tagging    then fail
    when :view       then fail
    when :vote       then fail
    when :watching   then fail
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

    case notification.resource.class.name.downcase.to_sym
    when :answer     then color[:resource], icon[:resource] = :'text-info',    :'exclamation-circle'
    when :comment    then color[:resource], icon[:resource] = :'text-warning', :comments
    when :evaluation then color[:resource], icon[:resource] = :'text-warning', :magic
    when :favorite   then color[:resource], icon[:resource] = :'text-warning', :star
    when :following  then color[:resource], icon[:resource] = :'text-info',    :link
    when :labeling   then color[:resource], icon[:resource] = :'text-success', :check
    when :question   then color[:resource], icon[:resource] = :'text-primary', :'question-circle'
    when :tagging    then color[:resource], icon[:resource] = :'text-primary', :tag
    when :view       then color[:resource], icon[:resource] = :'text-muted',   :eye
    when :vote       then color[:resource], icon[:resource] = :'text-muted',   :sort
    when :watching   then color[:resource], icon[:resource] = :'text-info',    :eye
    end

    { color: color, icon: icon }
  end
end
