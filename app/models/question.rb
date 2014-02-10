class Question < ActiveRecord::Base
  include Taggable
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

  validates :category,  presence: true
  validates :title,     presence: true, length: { minimum: 2, maximum: 250 }
  validates :text,      presence: true, length: { minimum: 2 }
  validates :anonymous, inclusion: { in: [true, false] }

  scope :answered, lambda { joins(:answers).uniq }
  scope :by,       lambda { |user| where(author: user) }

  before_create :set_slido_author, if: :slido_uuid?

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

  def set_slido_author
    self.author = User.find_by_login 'slido'
  end
end
