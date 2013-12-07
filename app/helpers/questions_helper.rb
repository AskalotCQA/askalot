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

  def question_answers_coloring(question)
    return :'text-danger' unless question.answers.any?
    return :'text-success' if question.answers.with(:best).any?

    :'text-muted'
  end

  def question_votes_coloring(question)
    :'text-muted'
  end

  def question_views_coloring(question)
    :'text-muted'
  end
end
