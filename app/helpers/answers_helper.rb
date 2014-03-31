module AnswersHelper
  def answer_highlighted?(resource)
      resource.author.role?(:teacher) && !resource.author.role?(:administrator)
  end

  def answer_evaluations_coloring(answer)
    evaluation_data(answer)[:color]
  end

  def answer_votes_coloring(answer)
    question_votes_coloring(answer.question)
  end

  def link_to_answer(answer, options = {})
    link_to_question answer.to_question, options.merge(anchor: "answer-#{answer.id}", deleted: answer.deleted?)
  end
end
