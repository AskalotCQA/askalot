module Shared
class Question < ActiveRecord::Base
  include Shared::Authorable
  include Shared::Closeable
  include Shared::Commentable
  include Shared::Deletable
  include Shared::Evaluable
  include Shared::Editable
  include Shared::Favorable
  include Shared::Notifiable
  include Shared::Orderable
  include Shared::Taggable
  include Shared::Touchable
  include Shared::Viewable
  include Shared::Votable
  include Shared::Watchable

  include Shared::Questions::Searchable

  # TODO (jharinek) propose change to parent tags
  before_save { self.tag_list += (new_record? ? category.effective_tags : category.tags) if category }

  after_create { self.register_question() }
  #after_destroy { self.category.reload_question_counters if self.category }

  belongs_to :category, counter_cache: true
  belongs_to :document, class_name: :'University::Document', counter_cache: true

  has_many :answers, dependent: :destroy

  has_many :revisions, class_name: :'Question::Revision', dependent: :destroy
  has_many :profiles, class_name: :'Question::Profile', dependent: :destroy
  has_many :category_questions, dependent: :destroy

  validates :category,  presence: true, if: lambda { |question| question.document.blank? }
  validates :document,  presence: true, if: lambda { |question| question.category.blank? }

  validates :title,     presence: true, length: { minimum: 2, maximum: 140 }
  validates :text,      presence: true, length: { minimum: 2 }
  validates :anonymous, inclusion: { in: [true, false] }

  scope :with_category, lambda { where.not(category: nil) }
  scope :with_document, lambda { where.not(document: nil) }

  scope :random,       lambda { with_category.select('questions.*, random()').order('random()') }
  scope :recent,       lambda { with_category.order(touched_at: :desc) }
  scope :unanswered,   lambda { unclosed.with_category.includes(:answers).where(answers: { question_id: nil }) }
  scope :answered,     lambda { with_category.joins(:answers).uniq }
  scope :all_answered, lambda { joins(:answers).uniq }
  scope :solved,       lambda { with_category.joins(:answers).merge(best_answers).references(:labelings).uniq }

  scope :answered_but_not_best, lambda { with_category.joins(:answers).where('questions.id not in (?)', joins(:answers).merge(best_answers).references(:labeling).uniq.select('questions.id')).uniq }

  scope :all_directly_related, lambda { |category| category.all_directly_related_questions(self) }
  scope :all_related, lambda { |category_ids| Category.all_related_questions_for_categories(self, category_ids) }

  scope :by, lambda { |user| where(author: user) }

  self.updated_timestamp = [:updated_at, :touched_at]

  self.table_name = 'questions'

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

  def reputation
    self.profiles.for('reputation').first_or_create do |p|
      p.property    = 'reputation'
      p.value       = 0
      p.probability = 0
    end
  end

  def register_question
    self.category.self_and_ancestors.each do |ancestor|
      CategoryQuestion.create question_id: self.id, category_id: ancestor.id, shared: false
      ancestor.all_versions.shared.each do |shared|
        CategoryQuestion.create question_id: self.id, category_id: shared.id, shared: true
      end
    end
  end

  # TODO (jharinek) delete when refactoring watchings
  def parent
    category || document
  end
end
end
