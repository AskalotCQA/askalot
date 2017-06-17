module Shared
class TagSerializer < ActiveModel::Serializer
  attribute :id do
    object.name
  end

  attribute :text do
    object.name + ' (' + object.count.to_s + ')'
  end
end
end
