class Question < ActiveRecord::Base
  include Commentable
  include Deletable
  include Evaluable
  include Favorable
  include Notifiable
  include Taggable
  include Viewable
  include Votable
  include Watchable

  before_save :add_category_tags

  belongs_to :author, class_name: :User, counter_cache: true
  belongs_to :category, counter_cache: true

  has_many :answers, dependent: :destroy

  validates :category,  presence: true
  validates :title,     presence: true, length: { minimum: 2, maximum: 140 }
  validates :text,      presence: true, length: { minimum: 2 }
  validates :anonymous, inclusion: { in: [true, false] }

  default_scope lambda { where(deleted: false) }

  scope :random,     lambda { select('questions.*, random()').order('random()') }
  scope :unanswered, lambda { includes(:answers).where(answers: { question_id: nil }) }
  scope :answered,   lambda { joins(:answers).where('questions.id not in (?)', joins(:answers).merge(best_answers).uniq.select('questions.id')).uniq }
  scope :solved,     lambda { joins(:answers).merge(best_answers).uniq }

  scope :by, lambda { |user| where(author: user) }

  def self.best_answers
    Answer.labeled_with(Label.where(value: :best).first)
  end

  def ordered_answers
    best  = answers.labeled_with(:best).first
    other = answers.by_votes.order(created_at: :desc)

    best ? [best] + other.where('id != ?', best.id) : other
  end

  def labels
    [category] + tags
  end

  def to_question
    self
  end

  private

  def add_category_tags
    self.tag_list += self.category.tags
  end
end
