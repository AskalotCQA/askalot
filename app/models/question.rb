class Question < ActiveRecord::Base
  include Commentable
  include Evaluable
  include Favorable
  include Taggable
  include Viewable
  include Votable
  include Watchable

  before_save :add_category_tags

  belongs_to :author, class_name: :User, counter_cache: true
  belongs_to :category, counter_cache: true

  has_many :answers
  has_many :labels, through: :labelings, through: :answers

  validates :category,  presence: true
  validates :title,     presence: true, length: { minimum: 2, maximum: 250 }
  validates :text,      presence: true, length: { minimum: 2 }
  validates :anonymous, inclusion: { in: [true, false] }

  scope :random,     lambda { select('questions.*, random()').order('random()') }
  scope :unanswered, lambda { includes(:answers).where(answers: { question_id: nil }) } #TODO(zbell) fix this, orders in controller fails
  scope :answered,   lambda { joins(:answers).uniq }
  scope :solved,     lambda { joins(:labels).uniq } #TODO(zbell) fix this

  scope :by, lambda { |user| where(author: user) }

  def answers_ordered
    best  = answers.labeled_with(:best).first
    other = answers.order(votes_total: :desc, created_at: :desc)

    best ? [best] + other.where('id != ?', best.id) : other
  end

  before_create :set_slido_author, if: :slido_uuid?

  def labels
    [category] + tags_with_counts
  end

  def tags_with_counts
    tags.each { |tag| tag.count = Question.tagged_with(tag.name).count }
  end

  private

  def add_category_tags
    self.tag_list += self.category.tags
  end

  def set_slido_author
    self.author = User.find_by_login 'slido'
  end
end
