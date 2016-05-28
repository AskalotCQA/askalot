module Shared::QuestionTypesHelper
  def question_type_icon(type)
    mode = type ? type.mode.to_s : 'question'

    return if mode == 'question'

    question_type_icon_force type
  end

  def question_type_icon_force(type)
    mode  = type ? type.mode.to_s : 'question'
    icon  = type ? type.icon : 'fa-question'
    color = type ? type.color : '#000000'
    name  = type ? type.name : 'Question'

    class_type = 'warning' if mode == 'forum'
    class_type = 'info' if mode == 'document'

    options = {class: "fa #{icon}", style: "color: #{color};"}
    options = options.deep_merge tooltip_attributes(name)

    content_tag :i, nil, options
  end
end