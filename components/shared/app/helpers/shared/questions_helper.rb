module Shared::QuestionsHelper
  def question_title_preview(question, options = {})
    html_escape truncate(html_escape(question.title), default_truncate_options.merge(length: 120).merge(options))
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

    return link_to question_label_name(label), shared.questions_path(tags: filter, category: params[:category]), analytics_attributes(model, :click, label.name).deep_merge(options) if label.is_a? Shared::Tag
    link_to question_label_name(label), shared.questions_path(category: label.id), analytics_attributes(model, :click, label.name).deep_merge(options)
  end

  def link_to_question(question, options = {})
    link_to_resource question, options
  end

  private

  def question_label_attributes(label)
    return :tag, [label.name], [:label, :'label-info', :'question-tag'] unless label.is_a? Shared::Category
    return :category, [label.id], [:label, :'label-primary', :'question-category']
  end

  def question_label_name(label)
    name = label.name
    name = label.full_public_name unless (label.class.to_s == 'Shared::Tag') || (label.root?)

    return (name + ' ' + fa_icon(:university, tooltip_attributes(names_for_teachers(label.teachers)).merge({ class: 'supported-category-icon-sm' })) + ' ').html_safe if label.is_a?(Shared::Category) && label.has_teachers?
    name
  end
end
