module Shared::QuestionTypesHelper
  def question_type_text_class(type)
    return 'text-primary' if type.mode == 'question'
    return 'text-warning' if type.mode == 'forum'
    return 'text-info' if type.mode == 'document'
  end
end
