module Shared::AnswersHelper
  def answer_highlighted?(answer)
    return false if answer.anonymous?

    answer.author.assigned?(answer.to_question.category, :teacher) || answer.author.assigned?(answer.to_question.category, :teacher_assistant)
  end

  def answer_text_preview(answer, options = {})
    preview_content answer.text, options.reverse_merge(length: 200)
  end

  def answer_evaluations_coloring(answer)
    evaluation_data(answer)[:color]
  end

  def answer_votes_coloring(answer)
    question_votes_coloring(answer.question)
  end

  def link_to_answer(answer, options = {})
    link_to_resource answer, options.merge(anchor: "answer-#{answer.id}")
  end
end
