module GravatarHelper
  def gravatar_url(email, options = {})
    hash    = Digest::MD5::hexdigest(email).downcase
    rating  = options[:rating]  || :g
    size    = options[:size]    || 80
    default = options[:default] || github_identicon_url(email_to_github_user email)

    "https://gravatar.com/avatar/#{hash}?r=#{rating}&s=#{size}&d=#{default}"
  end

  def gravatar_image_tag(email, options = {})
    classes = options.delete(:class)

    image_tag gravatar_url(email, options), alt: nil, class: classes
  end

  def github_identicon_url(user)
    "https://identicons.github.com/#{user}.png"
  end

  private

  def email_to_github_user(email)
    '%02d' % (MurmurHash3::V32.str_hash(email) % 100)
  end
end
