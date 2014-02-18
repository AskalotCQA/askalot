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

  def reversed_check_box(method, options = {}, checked_value = '1', unchecked_value = '0')
    check_box method, options, unchecked_value, checked_value
  end
end
