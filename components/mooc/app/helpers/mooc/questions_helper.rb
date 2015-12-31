module Mooc::QuestionsHelper
  extend Shared::QuestionsHelper

  def question_prefix_label(label, page_url, options = {})
    model, tags, classes = question_label_attributes label

    filter = ((params[:tags] || '').split(',') + tags).uniq.join(',')

    options.merge!(class: classes, target: '_parent')
    options.deep_merge! class: classes, data: { id: filter } unless filter.blank?

    href = (page_url ? page_url + '?redirect=' : '') + shared.questions_path(tags: filter)
    link_to question_label_name(label), href, analytics_attributes(model, :click, label.name).deep_merge(options)
  end
end
