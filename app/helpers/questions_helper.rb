module QuestionsHelper
  def question_creation_time(question, options = {})
    tooltip_time_tag question.created_at, { format: :normal, placement: :right }.merge(options)
  end

  def question_title_preview(question, options = {})
    truncate question.title, length: 120, separator: ' '
  end

  def question_text_preview(question, options = {})
    truncate question.text, length: 200, separator: ' '
  end
end
