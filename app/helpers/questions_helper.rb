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
    return :'text-warning' if question.answers.with(:helpful).any?

    :'text-muted'
  end

  def question_votes_coloring(question)
    :'text-muted'
  end

  def question_views_coloring(question)
    :'text-muted'
  end

  def question_label(label, options = {})
    values, classes = question_label_attributes label
    filter          = Array.wrap(params[:tags]) + values

    filter = Array.wrap(params[:tags]) + values

    options.merge! class: "label #{classes}"
    options.deep_merge! data: { id: values.join(',') }

    # TODO (smolnar) using only tags as parameter is possibly dangerous, review
    # TODO (zbell) why dangerous?
    link_to "#{label.name} (#{label.count})", questions_path(tags: filter), options
  end

  private

  def question_label_attributes(label)
    return [label.name], [:label, :'label-info', :'question-tag'] unless label.is_a? Category
    return label.tags.to_a, [:label, :'label-primary', :'question-category']
  end
end
