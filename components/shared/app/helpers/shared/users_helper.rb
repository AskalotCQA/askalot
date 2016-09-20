module Shared::UsersHelper
  def user_avatar_tag(user, options = {})
    classes = [:'user-avatar'] + Array.wrap(options.delete :class)
    image   = options.delete(:image) || {}
    size    = options.delete(:size)

    classes << :'user-avatar-inline' if options.delete(:inline)

    if size
      classes << "user-avatar-#{size}"
    else
      classes << case image[:size]
      when   0.. 20 then :'user-avatar-xs'
      when  21.. 80 then :'user-avatar-sm'
      when  81..240 then nil
      else               :'user-avatar-lg'
      end
    end

    wrapped_user_image_tag user, image, options.merge(class: classes)
  end

  def user_icon_tag(user, options = {})
    classes = [:'user-avatar-icon'] + Array.wrap(options.delete :class)
    image   = options.delete(:image) || {}

    image[:class] = [:'img-icon']
    image[:class] = :'img-muted' if options.delete(:muted)

    wrapped_user_image_tag user, image, options.merge(class: classes)
  end

  def user_nick(user, options = {})
    user == :anonymous ? t('user.anonymous') : user.nick
  end

  def link_to_user(user, options = {})
    authorable = options.delete(:authorable)

    user = (user == authorable.author ? authorable.author_or_anonymous : user) if authorable

    return content_tag :span, t('user.anonymous'), options if user == :anonymous

    body = options.delete(:body) || user.nick
    url  = options.delete(:url)
    path = options.delete(:absolute_url) ? shared.user_url(user.nick) : shared.user_path(user.nick)

    url = url.is_a?(Proc) ? url.call(path) : path

    link_to body, url, options
  end

  private

  def anonymous_gravatar_image_tag(options = {})
    gravatar_image_tag 'anonymous@fiit.stuba.sk', options.merge(default: image_url('shared/anonymous.png'), alt: :anonymous)
  end

  def wrapped_user_image_tag(user, image, options = {})
    if user == :anonymous
      tag = anonymous_gravatar_image_tag image
    else
      tag = gravatar_image_tag user.gravatar_email, image.merge(alt: user.nick)
    end

    url = options.delete(:url)

    return content_tag :span, tag, options if options.delete(:link) == false || user == :anonymous

    link_to tag, url || shared.user_path(user.nick), options
  end
end
