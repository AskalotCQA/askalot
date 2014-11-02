class Question < ActiveRecord::Base
  include Authorable
  include Commentable
  include Deletable
  include Evaluable
  include Editable
  include Favorable
  include Notifiable
  include Orderable
  include Taggable
  include Touchable
  include Viewable
  include Votable
  include Watchable

  include Questions::Searchable

  # TODO (jharinek) propose change to parent tags
  before_save { self.tag_list += self.category.tags if category }

  belongs_to :category, counter_cache: true
  belongs_to :document, counter_cache: true

  has_many :answers, dependent: :destroy

  has_many :revisions, class_name: :'Question::Revision', dependent: :destroy

  validates :category,  presence: true, if: lambda { |question| question.document.blank? }
  validates :document,  presence: true, if: lambda { |question| question.category.blank? }

  validates :title,     presence: true, length: { minimum: 2, maximum: 140 }
  validates :text,      presence: true, length: { minimum: 2 }
  validates :anonymous, inclusion: { in: [true, false] }

  scope :random,     lambda { select('questions.*, random()').order('random()') }
  scope :recent,     lambda { order(touched_at: :desc) }
  scope :unanswered, lambda { includes(:answers).where(answers: { question_id: nil }) }
  scope :answered,   lambda { joins(:answers).uniq }
  scope :solved,     lambda { joins(:answers).merge(best_answers).references(:labelings).uniq }

  scope :answered_but_not_best, lambda { joins(:answers).where('questions.id not in (?)', joins(:answers).merge(best_answers).references(:labeling).uniq.select('questions.id')).uniq }

  scope :by, lambda { |user| where(author: user) }

  self.updated_timestamp = [:updated_at, :touched_at]

  def self.best_answers
    Answer.labeled_with(Label.where(value: :best).first)
  end

  def ordered_answers
    best  = answers.labeled_with(:best).first
    other = answers.by_votes.order(created_at: :desc)

    best ? [best] + other.where('id != ?', best.id) : other
  end

  def labels
    category ? [category] + tags : tags
  end

  def to_question
    self
  end

  def parent
    category || document
  end
end
