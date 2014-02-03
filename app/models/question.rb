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

  validates :title,     presence: true, length: { minimum: 2, maximum: 250 }
  validates :text,      presence: true, length: { minimum: 2 }
  #validates :anonymous, presence: true #TODO(zbell) Rasto: uncomment this when tests do not fail because of it

  scope :answered, lambda { joins(:answers).uniq }
  scope :by,       lambda { |user| where(author: user) }

  def labels
    [category] + tags_with_counts
  end

  def tags_with_counts
    tags.each do |tag|
      tag.count = Question.tagged_with(tag.name).count
    end

    tags
  end

  def answers_ordered
    best_answer = answers.labeled_with :best

    return best_answer + answers.order('votes_total desc, created_at desc').where('id != ?', best_answer[0].id) if !best_answer.empty?  

    answers.order('votes_total desc, created_at desc')
  end

  private

  def add_category_tags
    self.tag_list += self.category.tags
  end
end
