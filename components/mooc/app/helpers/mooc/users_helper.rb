module Mooc::UsersHelper
  extend Shared::UsersHelper

  def link_to_user_unit(user, page_url = nil, options = {})
    authorable = options.delete(:authorable)
    user = (user == authorable.author ? authorable.author_or_anonymous : user) if authorable
    href = (page_url ? page_url + '#' : '') + shared.user_path(user.nick)

    options.merge!(target: '_parent')

    return content_tag :span, t('user.anonymous'), options if user == :anonymous

    link_to user.nick, href, options
  end
end
