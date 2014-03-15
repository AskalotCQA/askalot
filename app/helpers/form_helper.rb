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

  def form_messages(flash: self.flash, key: nil, resource: nil)
    flash = flash[:form] || {}
    store = flash[key != nil ? key.to_s : :global].to_a

    resource.errors.full_messages.reject(&:blank?).each { |message| store << [:error, message] } if resource

    render 'shared/form_messages', store: store
  end

  #TODO key vs active keys ??
  def form_messages_for(resource, flash: self.flash, key: nil)
    form_messages resource: resource, flash: flash, key: key
  end

  def form_message_type_to_class(type)
    { alert: :danger, error: :danger, failure: :danger, notice: :info }[type] || type
  end

  def reversed_check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
    check_box method, options, unchecked_value, checked_value
  end
end
