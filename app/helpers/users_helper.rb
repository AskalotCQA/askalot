module UsersHelper
  def user_avatar_tag(user, options = {})
    classes = [:'user-avatar'] + Array.wrap(options.delete :class)
    image   = options[:image] || {}

    if options[:size]
      classes << "user-avatar-xs-#{options[:size]}"
    else
      classes << case image[:size]
      when   0.. 20 then :'user-avatar-xs'
      when  21.. 80 then :'user-avatar-sm'
      when  81..240 then nil
      else               :'user-avatar-lg'
      end
    end

    if user == :anonymous
      return content_tag :span, class: classes do
        gravatar_image_tag 'anonymous@fiit.stuba.sk', image.merge(default: image_url('anonymous.png'), alt: :anonymous)
      end
    end

    link_to options[:url] || user_path(user.nick), class: classes do
      gravatar_image_tag user.gravatar_email, image.merge(alt: user.nick)
    end
  end

  def link_to_user(user, options = {})
    return t('user.anonymous') if user == :anonymous

    link_to user.nick, user_path(user.nick), options
  end
end
