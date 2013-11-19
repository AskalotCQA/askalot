module AnswersHelper
  def answer_creation_time(answer, options = {})
    tooltip_time_tag answer.created_at, options.merge(format: :normal, placement: :right)
  end
end
