class Tag < ActsAsTaggableOn::Tag
  before_save :normalize

  has_many :watchings, as: :watchable

  def normalize
    self.name = name.downcase.gsub(/[^[:alnum:]]+/, '-').gsub(/\A-|-\z/, '')
  end
end
