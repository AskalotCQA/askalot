module QuestionsHelper
  def question_creation_time(question, options = {})
    tooltip_time_tag question.created_at, { format: :normal, placement: :right }.merge(options)
  end
end
