module UsersHelper
  def user_avatar_tag(user, options = {})
    classes = [:'user-avatar'] + Array.wrap(options.delete :class)
    image   = options[:image] || {}

    if options[:size]
      classes << "user-avatar-#{options[:size]}"
    else
      classes << case image[:size]
      when   0.. 20 then :'user-avatar-xs'
      when  21.. 80 then :'user-avatar-sm'
      when  81..240 then nil
      else               :'user-avatar-lg'
      end
    end

    return content_tag :span, anonymous_gravatar_image_tag(image), class: classes if user == :anonymous

    link_to options[:url] || user_path(user.nick), class: classes do
      gravatar_image_tag user.gravatar_email, image.merge(alt: user.nick)
    end
  end

  def icon_link_to_user(user, options = {})
    return content_tag :span, anonymous_gravatar_image_tag(image), options if user == :anonymous

    link_to gravatar_image_tag(user.gravatar_email, class: 'user-avatar-icon', alt: user.nick), user_path(user.nick), options
  end

  def link_to_user(user, options = {})
    return content_tag :span, t('user.anonymous'), options if user == :anonymous

    link_to user.nick, user_path(user.nick), options
  end

  private

  def anonymous_gravatar_image_tag(options = {})
    gravatar_image_tag 'anonymous@fiit.stuba.sk', options.merge(default: image_url('anonymous.png'), alt: :anonymous)
  end
end
