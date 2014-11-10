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

  def role_collection_select(id, collection = Role.all.order(:name), value = :id, label = :name, options = {}, html_options = {})
    options.merge! include_blank: true
    html_options.deep_merge! class: :'form-control', data: { as: :select2 }

    collection_select(id, collection, value, label, options, html_options)
  end

  def visibility_collection_select(id, collection = { public: I18n.t('group.visibility.public'), private: I18n.t('group.visibility.private') }, value = :first, label = :last, options = {}, html_options = {})
    options.merge! include_blank: false
    html_options.deep_merge! class: :'form-control', data: { as: :select2 }

    collection_select(id, collection, value, label, options, html_options)
  end

  def form_messages(flash: self.flash, key: nil, resource: nil, context: form_messages_context)
    flash = flash[:form] || {}
    key   = (key || :global).to_sym
    store = flash[key].to_a

    if resource && key == context[:key].to_sym
      resource.errors.full_messages.reject(&:blank?).each { |message| store << [:error, message] }
    end

    render context[:partial], messages: store
  end

  def form_messages_context
    { key: (params[:tab] || :global).to_sym, partial: 'shared/form_messages' }
  end

  def form_messages_for(resource, options = {})
    form_messages(resource: resource, **options)
  end

  def form_message_type_to_class(type)
    { alert: :danger, error: :danger, failure: :danger, notice: :info, slido: :info }[type.to_sym] || type
  end

  def reversed_check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
    check_box method, options, unchecked_value, checked_value
  end
end
