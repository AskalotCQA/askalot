module QuestionsHelper
  def question_title_preview(question, options = {})
    html_escape truncate(question.title, default_truncate_options.merge(length: 120).merge(options))
  end

  def question_text_preview(question, options = {})
    html_escape preview_content question.text, options.reverse_merge(length: 200)
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
    model, tags, classes = question_label_attributes label

    filter = ((params[:tags] || '').split(',') + tags).uniq.join(',')

    options.merge!(class: classes)
    options.deep_merge! class: classes, data: { id: filter } unless filter.blank?

    link_to label.name, questions_path(tags: filter), analytics_attributes(model, :click, label.name).deep_merge(options)
  end

  def link_to_question(question, options = {})
    link_to_resource question, options
  end

  private

  def question_label_attributes(label)
    return :tag, [label.name], [:label, :'label-info', :'question-tag'] unless label.is_a? Category
    return :category, label.tags.to_a, [:label, :'label-primary', :'question-category']
  end
end
