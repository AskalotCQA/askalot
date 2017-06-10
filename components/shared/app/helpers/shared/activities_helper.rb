module Shared::ActivitiesHelper
  def activity_icon_tag(activity, options = {})
    data    = activity_data activity
    mute    = options.delete(:mute) || lambda { |_| false }
    color   = !mute.call(activity) ? data[:color][:action] : :'text-muted'
    type    = activity.action == :mention ? :mention : :persistence
    title   = t "activity.icon.#{type}", action: t("activity.action.#{activity.action}"), resource: t("activity.content.#{type}.#{activity.resource.class.name.demodulize.downcase}")
    options = options.merge(tooltip_attributes title, placement: :bottom)

    icon_tag data[:icon][:resource], options.merge(class: color, fixed: true)
  end

  def activity_content(activity, options = {})
    content = activity_content_by_attributes(activity.action, activity.initiator, activity.resource, options)

    options.delete(:mute).try(:call, activity) ? content_tag(:span, content, class: :'text-muted') : content
  end

  def activity_content_by_attributes(action, initiator, resource, options = {})
    content = activity_content_pattern(action, resource)

    if resource.class.name == 'Shared::Following'
      follower_link = link_to_activity_by_attributes action, initiator, resource, options.merge(length: 50)

      translate(content, follower: follower_link).html_safe
    else
      question = resource.to_question

      resource_options = options.clone
      question_options = options.merge(deleted: question.deleted?, length: 50)

      resource_body = activity_resource_body(action, resource, resource_options)
      question_body = activity_question_body(action, question, question_options)

      # TODO(zbell) note that unlinked content also lacks any struct info about deletion: no muted spans
      if options.delete(:unlink)
        options[:mute] = true

        return translate content, resource: resource_body, question: question_body
      end

      resource_link = link_to_activity_by_attributes action, initiator, resource, resource_options.merge(body: resource_body)
      question_link = link_to_activity_by_attributes action, initiator, resource, question_options.merge(body: question_body)

      translate(content, resource: resource_link, question: question_link).html_safe
    end
  end

  def link_to_activity(activity, options = {}, &block)
    link_to_activity_by_attributes(activity.action, activity.initiator, activity.resource, options, &block)
  end

  def link_to_activity_by_attributes(action, initiator, resource, options = {}, &block)
    options[:body] = capture(&block) if block_given?

    # TODO(zbell) add specific link_to_* helpers for all cases
    case resource.class.name.demodulize.downcase.to_sym
    when :answer     then link_to_answer resource, options
    when :comment    then link_to_comment resource, options
    when :evaluation then link_to_evaluation resource, options
    when :favorite   then link_to_favorite resource, options
    when :following  then link_to_following resource, options
    when :labeling   then link_to_labeling resource, options
    when :question   then link_to_question resource, options
    when :tagging    then fail
    when :view       then fail
    when :vote       then fail
    when :watching   then fail
    else fail
    end
  end

  private

  def activity_data(activity)
    color, icon = {}, {}

    case activity.action
    when :create  then color[:action], icon[:action] = :'text-success', :check
    when :update  then color[:action], icon[:action] = :'text-info',    :pencil
    when :delete  then color[:action], icon[:action] = :'text-danger',  :times
    when :mention then color[:action], icon[:action] = :'text-warning', :bolt
    end

    case activity.resource.class.name.demodulize.downcase.to_sym
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

  def activity_content_pattern(action, resource)
    case resource.class.name.demodulize.downcase.to_sym
    when :comment then "activity.content.#{resource.class.name.demodulize.downcase}.#{resource.commentable.class.name.demodulize.downcase}.#{action}"
    when :evaluation then "activity.content.#{resource.class.name.demodulize.downcase}.#{resource.evaluable.class.name.demodulize.downcase}.#{action}"
    else "activity.content.#{resource.class.name.demodulize.downcase}.#{action}"
    end
  end

  def activity_question_body(action, question, options = {})
    question_title_preview question, extract_truncate_options!(options)
  end

  def activity_resource_body(action, resource, options = {})
    translate "activity.content.#{action == :mention ? :mention : :persistence}.#{resource.class.name.demodulize.downcase}"
  end
end
