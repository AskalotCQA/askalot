module Shared::QuestionTypesHelper
  def question_type_icon(type)
    return if type.mode.to_s == 'question'

    class_type = 'warning' if type.mode.to_s == 'forum'
    class_type = 'info' if type.mode.to_s == 'document'

    options = {class: "fa #{type.icon}"}
    options = options.deep_merge tooltip_attributes(type.name)


    content_tag :span, class: "label label-#{class_type}" do
      content_tag :i, nil, options
    end
  end
end