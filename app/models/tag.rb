class Tag < ActiveRecord::Base
  include Notifiable
  include Watchable

  has_many :taggings, dependent: :restrict_with_exception

  scope :popular, lambda { select(' tags.*, count(*) as a').joins(:taggings).group('tags.id').order('a DESC')}

  before_save :normalize

  def count
    @count ||= taggings.select { |tagging|
      tagging.taggable ? true : false
    }.size
  end

  def normalize
    self.name = name.to_s.downcase.gsub(/[^[:alnum:]]+/, '-').gsub(/\A-|-\z/, '')
  end
end
