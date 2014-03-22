class Tag < ActiveRecord::Base
  include Watchable

  has_many :taggings, dependent: :restrict_with_exception

  scope :recent,  lambda { where('created_at >= ?', Time.now - 1.month ).order(:name) }
  scope :popular, lambda { select('tags.*, count(*) as c').joins(:taggings).group('tags.id').unscope(:order).order('c desc') }

  before_save :normalize

  def count
    #TODO(zbell) update count to be model specific: count(model = nil)
    #taggings.where(taggable_type: Question).undeleted.count

    #TODO(zbell) bug: do not cache this
    @count ||= taggings.select { |tagging|
      tagging.taggable ? true : false
    }.size
  end

  def normalize
    self.name = name.to_s.downcase.gsub(/[^[:alnum:]]+/, '-').gsub(/\A-|-\z/, '')
  end

  # TODO(zbell) rmend

  def questions
    Question.tagged_with(self.name)
  end
end
