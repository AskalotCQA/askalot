module Mooc::QuestionsHelper
  extend Shared::QuestionsHelper

  def question_prefix_label(label, page_url, options = {}, in_questions_index = false)
    model, tags, classes = question_label_attributes label

    filter = ((params[:tags] || '').split(',') + tags).uniq.join(',')

    options.merge!(class: classes)
    options.deep_merge! class: classes, data: { id: filter } unless filter.blank?

    if label.class.to_s == 'Shared::Category'
      href = (in_questions_index) ? '#' : mooc.unit_path(id: label.id)
    else
      href = (page_url ? page_url + '?redirect=' : '') + shared.questions_path(tags: filter)
      options.merge!(target: '_parent')
    end

    link_to question_label_name(label), href, analytics_attributes(model, :click, label.name).deep_merge(options)
  end
end
