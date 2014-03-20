class Tag < ActiveRecord::Base
  include Watchable

  has_many :taggings, dependent: :restrict_with_exception

  scope :popular, lambda { select('tags.*, count(*) as count_all').joins(:taggings).group('tags.id').order('count_all DESC')}
  scope :recent,  lambda { where('created_at >= ?', Time.now - 1.month ) }

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
