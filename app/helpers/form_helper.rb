module FormHelper
  def category_collection_select(id, collection = Category.all.order(:name), value = :id, label = :name, options = {}, html_options = {})
    tags = collection.inject({}) do |hash, category|
      hash[category.name] = category.tags
      hash
    end

    options.merge! include_blank: true
    html_options.deep_merge! class: :'form-control', data: { as: :select2, values: tags }

    collection_select(id, collection, value, label, options, html_options)
  end

  def form_messages(flash: self.flash, key: nil, resource: nil, context: { key: form_message_resource_key, partial: 'shared/form_messages' })
    flash = flash[:form] || {}
    store = flash[key != nil ? key.to_s : :global].to_a

    if resource && key == context[:key]
      resource.errors.full_messages.reject(&:blank?).each { |message| store << [:error, message] }
    end

    render context[:partial], store: store
  end

  def form_messages_for(resource, options = {})
    form_messages(resource: resource, **options)
  end

  def form_message_resource_key
    params[:tab].to_sym || :global
  end

  def form_message_type_to_class(type)
    { alert: :danger, error: :danger, failure: :danger, notice: :info }[type] || type
  end

  def reversed_check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
    check_box method, options, unchecked_value, checked_value
  end
end
