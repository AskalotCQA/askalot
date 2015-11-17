class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title

  has_one :author, serializer: UserSerializer
end
