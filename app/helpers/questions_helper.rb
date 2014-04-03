module QuestionsHelper
  def question_title_preview(question, options = {})
    html_escape truncate(question.title, default_truncate_options.merge(length: 120).merge(options))
  end

  def question_text_preview(question, options = {})
    preview_content question.text, options.reverse_merge(length: 200)
  end

  def question_answers_coloring(question)
    return :'text-danger' unless question.answers.any?
    return :'text-success' if question.answers.best.any?
    return :'text-warning' if question.answers.helpful.any?

    :'text-muted'
  end

  def question_evaluations_coloring(question)
    evaluation_data(question)[:color]
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
    body = options.delete(:body) || question_title_preview(question, extract_truncate_options!(options))
    path = question_path(question, anchor: options.delete(:anchor))
    path = options.delete(:path).call path if options[:path]

    if options.delete(:deleted) || question.deleted?
      delete = options.delete(:delete)

      return delete.call(body, path, options) if delete.is_a? Proc
      return content_tag :span, body, tooltip_attributes(t('question.link_to_deleted_title'), placement: :bottom).merge(options)
    end

    link_to body, path, options
  end

  private

  def question_label_attributes(label)
    return [label.name], [:label, :'label-info', :'question-tag'] unless label.is_a? Category
    return label.tags.to_a, [:label, :'label-primary', :'question-category']
  end
end
