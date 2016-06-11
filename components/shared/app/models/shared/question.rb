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

  after_create { self.register_question }
  after_update { self.register_question if changed.include? 'category_id' }

  belongs_to :category, counter_cache: true
  belongs_to :document, class_name: :'University::Document', counter_cache: true
  belongs_to :question_type

  has_many :answers, dependent: :destroy

  has_many :revisions, class_name: :'Question::Revision', dependent: :destroy
  has_many :profiles, class_name: :'Question::Profile', dependent: :destroy
  has_many :category_questions, dependent: :destroy
  has_many :related_categories, -> { distinct }, through: :category_questions, :source => :category

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
  scope :solved,       lambda { with_category.where(with_best_answer: true) }

  scope :of_type,      lambda { |type| joins(:question_type).where('question_types.mode' => type )}

  scope :answered_but_not_best, lambda { answered.where(with_best_answer: false) }

  scope :by, lambda { |user| where(author: user) }
  scope :in_context, lambda { |context| includes(:related_categories).where(categories: { id: context }) }

  self.updated_timestamp = [:updated_at, :touched_at]

  self.table_name = 'questions'

  def self.best_answers
    Answer.labeled_with(Label.where(value: :best).first)
  end

  def ordered_reactions
    return answers.order(created_at: :asc) if mode.forum?

    ordered_answers
  end

  def ordered_answers
    best  = answers.labeled_with(:best).first
    other = answers.by_votes.order(created_at: :desc)

    best ? [best] + other.where('id != ?', best.id) : other
  end

  def labels
    sorted_tags = tags.sort_by(&:name)
    [category] + sorted_tags if category
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
    return unless self.category
    return unless Shared::CategoryQuestion.table_exists?

    self.category_questions.delete_all

    self.category.self_and_ancestors.each do |ancestor|
      Shared::CategoryQuestion.create question_id: self.id, category_id: ancestor.id, shared: false
    end

    self.category.all_versions.shared.each do |shared|
      shared.self_and_ancestors.each do |c|
        Shared::CategoryQuestion.create question_id: self.id, category_id: c.id, shared: true, shared_through_category: shared
      end
    end
  end

  def related_contexts
    depth = Rails.module.mooc? ? 0 : 1;

    related_categories.where(depth: depth)
  end

  def available_in_current_context?
    self.related_contexts.where(id: Shared::Context::Manager.current_context).count > 0
  end

  # TODO (jharinek) delete when refactoring watchings
  def parent
    category || document
  end

  def parent_watchers
    if parent.class == Shared::Category
      parent.parent_watchers
    else
      parent.watchers
    end
  end

  def mode
    mode = self.question_type ? self.question_type.mode : 'question'

    ActiveSupport::StringInquirer.new mode.to_s
  end
end
end
