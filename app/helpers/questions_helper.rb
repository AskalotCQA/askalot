module QuestionsHelper
  def question_title_preview(question, options = {})
    truncate html_escape(question.title), default_truncate_options.merge(length: 120).merge(options)
  end

  def question_text_preview(question, options = {})
    truncate render_stripdown(question.text), default_truncate_options.merge(length: 200).merge(options)
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

  def link_to_question(question, options = {})
    title = question_title_preview(question, extract_truncate_options!(options))
    path  = question_path(question, anchor: options.delete(:anchor))

    link_to title, path, options
  end

  private

  def question_label_attributes(label)
    return [label.name], [:label, :'label-info', :'question-tag'] unless label.is_a? Category
    return label.tags.to_a, [:label, :'label-primary', :'question-category']
  end
end
