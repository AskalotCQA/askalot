class Question < ActiveRecord::Base
  include Commentable
  include Favorable
  include Taggable
  include Viewable
  include Votable
  include Watchable

  before_save :add_category_tags

  belongs_to :author, class_name: :User
  belongs_to :category

  has_many :answers
  has_many :labels, through: :labelings, through: :answers

  validates :title,     presence: true, length: { minimum: 2, maximum: 250 }
  validates :text,      presence: true, length: { minimum: 2 }
  #validates :anonymous, presence: true #TODO(zbell) Rasto: uncomment this when tests do not fail because of it

  scope :answered,    lambda { joins(:answers).uniq }
  scope :solved,      lambda { joins(:labels).uniq }
  scope :unanswered,  lambda { includes(:answers).where(answers: {question_id: nil}) }
  scope :by,          lambda { |user| where(author: user) }

  def labels
    [category] + tags_with_counts
  end

  def tags_with_counts
    tags.each do |tag|
      tag.count = Question.tagged_with(tag.name).count
    end

    tags
  end

  private

  def add_category_tags
    self.tag_list += self.category.tags
  end
end
