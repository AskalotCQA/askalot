module Shared
class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title

  attribute :author do
    user = object.anonymous? ? :anonymous : object.author
    {
        nick: user == :anonymous ? 'anonymous' : user.nick
    }
  end
end
end
