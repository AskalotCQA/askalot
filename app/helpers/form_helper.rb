module FormHelper
  def category_collection_select(id, collection = Category.all, value = :id, label = :name, options = {}, html_options = {})
    tags = collection.inject({}) do |hash, category|
      hash[category.name] = category.tags

      hash
    end

    html_options.deep_merge! class: :'form-control', data: { as: :select2, values: tags }

    collection_select(id, collection, value, label, options, html_options)
  end
end
