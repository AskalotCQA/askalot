class Question < ActiveRecord::Base
  include Commentable
  include Favorable
  include Viewable
  include Votable
  include Watchable

  belongs_to :author, class_name: :User
  belongs_to :category

  has_many :answers

  acts_as_taggable

  validates :title, presence: true, length: { minimum: 2, maximum: 250 }
  validates :text,  presence: true, length: { minimum: 2 }

  scope :answered,   lambda { joins(:answers).uniq }
  scope :favored,    lambda { joins(:favorites).uniq }
  scope :favored_by, lambda { |user| joins(:favorites).where(favorites: { favorer: user }) }

  def labels
    [category] + tags_with_counts
  end

  def tags_with_counts
    tags.each do |tag|
      tag.count = Question.tagged_with(tag.name).count
    end

    tags
  end
end
