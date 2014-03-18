module AnswersHelper
  def answer_highlighted?(resource)
      resource.author.role?(:teacher) && !resource.author.role?(:administrator)
  end

  def link_to_answer(answer, options = {})
    link_to_question answer.to_question, options.merge(anchor: "answer-#{answer.id}")
  end
end
