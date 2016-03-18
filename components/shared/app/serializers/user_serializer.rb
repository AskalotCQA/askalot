class UserSerializer < ActiveModel::Serializer
  attributes :id, :email, :nick, :gravatar_url

  def gravatar_url
    Helper.gravatar_url(object.email)
  end

  module Helper
    extend Shared::GravatarHelper
  end
end
