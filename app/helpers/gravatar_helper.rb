module
  def gravatar_url(email, options = {})
    hash   = Digest::MD5::hexdigest(email).downcase
    rating = options[:rating] || :g
    size   = options[:size] || 80

    "http://gravatar.com/avatar/#{hash}?r=#{rating}&s=#{size}"
  end
end