module Mooc::QuestionsHelper
  def question_prefix_label(label, page_url, options = {})
    puts 'In my question helper'
    model, tags, classes = question_label_attributes label

    filter = ((params[:tags] || '').split(',') + tags).uniq.join(',')

    options.merge!(class: classes)
    options.deep_merge! class: classes, data: { id: filter } unless filter.blank?

    link_to question_label_name(label), shared.questions_path(tags: filter), analytics_attributes(model, :click, label.name).deep_merge(options)
  end

  def link_to_question(question, options = {})
    link_to_resource question, options
  end

  private

  def question_label_attributes(label)
    return :tag, [label.name], [:label, :'label-info', :'question-tag'] unless label.is_a? Shared::Category
    return :category, label.tags.to_a, [:label, :'label-primary', :'question-category']
  end

  def question_label_name(label)
    name = label.name
    name = label.parent.name + ' - ' + label.name unless (label.class.to_s == 'Shared::Tag') || (label.root?)

    return (name + ' ' + fa_icon(:university, tooltip_attributes(names_for_teachers(label.teachers)).merge({ class: 'supported-category-icon-sm' })) + ' ').html_safe if label.is_a?(Shared::Category) && label.has_teachers?
    name
  end
end
