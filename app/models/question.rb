class Question < ActiveRecord::Base
  belongs_to :author, class_name: :User
  belongs_to :category

  has_many :answers

  has_many :favorites
  has_many :favorers, through: :favorites, source: :user

  has_many :watchings, as: :watchable

  has_many :votes, as: :votable

  acts_as_taggable

  validates :title, presence: true, length: { minimum: 2, maximum: 250 }
  validates :text,  presence: true, length: { minimum: 2 }

  scope :favored_by, lambda { |user| joins(:favorites).where(favorites: { user: user }) }

  def labels
    [category] + tags_with_counts
  end

  def tags_with_counts
    tags.each do |tag|
      tag.count = Question.tagged_with(tag.name).count
    end

    tags
  end

  def favored_by?(favorer)
    favorites.exists? user: favorer
  end

  def toggle_favoring_by!(user)
    return Favorite.create! user: user, question: self unless favored_by?(user)

    Favorite.where(user: user, question: self).first.destroy
  end

  def toggle_voteup_by!(voter)
    if voted_by?(voter)
      vote = votes.where(voter: voter).first
      if vote.upvote
        vote.destroy
      else
        vote.upvote = true
        vote.save
      end
    else
      votes.create!(voter: voter)
    end
  end

  def toggle_votedown_by!(voter)
    if voted_by?(voter)
      vote = votes.where(voter: voter).first
      if vote.upvote
        vote.upvote = false
        vote.save
      else
        vote.destroy
      end
    else
      votes.create!(voter: voter, upvote: false)
    end
  end

  def voted_by?(voter)
    votes.exists?(voter: voter)
  end

  def upvoted_by?(voter)
    votes.exists?(voter: voter, upvote: true)
  end

  def downvoted_by?(voter)
    votes.exists?(voter: voter, upvote: false)
  end

  def num_votes
    votes.where(upvote: true).count-votes.where(upvote: false).count
  end
end
