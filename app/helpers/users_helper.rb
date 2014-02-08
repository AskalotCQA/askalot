module UsersHelper
  def user_avatar_tag(user, options = {})
    if user == :anonymous
      return content_tag :span, class: :'user-avatar' do
        gravatar_image_tag 'anonymous@askalot.fiit.stuba.sk', options
      end
    end

    link_to user_path(user.nick), class: :'user-avatar' do
      gravatar_image_tag user.gravatar_email, options
    end
  end

  def link_to_user(user, options = {})
    return t('user.anonymous') if user == :anonymous

    link_to user.nick, user_path(user.nick), options
  end
end
