module QuestionsHelper
  def question_creation_time(question, options = {})
    tooltip_time_tag question.created_at, options.merge(format: :normal, placement: :right)
  end
end
