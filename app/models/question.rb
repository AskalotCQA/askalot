class Question < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :category

  has_many :answers

  has_many :favorites
  has_many :favourers, through: :favorites, source: :user

  has_many :watchings, as: :watchable

  acts_as_taggable

  validates :title, presence: true, length: { minimum: 2, maximum: 250 }
  validates :text,  presence: true, length: { minimum: 2 }

  def labels
    [category] + tags_with_counts
  end

  def tags_with_counts
    tags.each do |tag|
      tag.count = Question.tagged_with(tag.name).count
    end

    tags
  end

  def favoured_by?(favourer)
    !!favourers.include?(favourer)
  end

  def favour_by!(user)
    return Favorite.create! question: self, user: user unless favoured_by?(user)

    Favorite.find_by(question_id: self.id, user_id: user.id).destroy
  end
end
