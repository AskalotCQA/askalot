module GravatarHelper
  def gravatar_url(email, options = {})
    hash   = Digest::MD5::hexdigest(email).downcase
    rating = options[:rating] || :g
    size   = options[:size] || 80

    "http://gravatar.com/avatar/#{hash}?r=#{rating}&s=#{size}"
  end

  def gravatar_image_tag(email, options = {})
    classes = options.delete(:class)

    image_tag gravatar_url(email, options), alt: nil, class: classes
  end
end