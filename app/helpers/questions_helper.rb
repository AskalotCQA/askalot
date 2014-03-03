module QuestionsHelper
  def question_creation_time(question, options = {})
    tooltip_time_tag question.created_at, { format: :normal, placement: :right }.merge(options)
  end

  def question_title_preview(question, options = {})
    truncate question.title, length: 120, separator: ' '
  end

  def question_text_preview(question, options = {})
    truncate render_stripdown(question.text), length: 200, separator: ' '
  end

  def question_answers_coloring(question)
    return :'text-danger' unless question.answers.any?
    return :'text-success' if question.answers.best.any?
    return :'text-warning' if question.answers.helpful.any?

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
    filter          = ((params[:tags] || '').split(',') + values).uniq.join(',')

    options.merge!(class: classes)
    options.deep_merge! class: classes, data: { id: filter } unless filter.blank?

    link_to label.name, questions_path(tags: filter), options
  end

  private

  def question_label_attributes(label)
    return [label.name], [:label, :'label-info', :'question-tag'] unless label.is_a? Category
    return label.tags.to_a, [:label, :'label-primary', :'question-category']
  end
end
