class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :nick, :gravatar_url

  def gravatar_url
    GravatarHelper.gravatar_url(object.email)
  end
end
