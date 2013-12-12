module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
    has_many :voters, through: :votes, source: :voter

    scope :voted, lambda { joins(:votes).uniq }
  end

  def voted_by?(user)
    votes.exists?(voter: user)
  end

  def upvoted_by?(user)
    votes.exists?(voter: user, upvote: true)
  end

  def downvoted_by?(user)
    votes.exists?(voter: user, upvote: false)
  end

  def toggle_vote_by!(user, upvote)
    return votes.create! voter: user, upvote: upvote unless voted_by? user

    vote = votes.where(voter: user).first

    return vote.destroy if vote.upvote == upvote

    vote.upvote = upvote
    vote.save!
  end

  def toggle_voteup_by!(user)
    toggle_vote_by! user, true
  end

  def toggle_votedown_by!(user)
    toggle_vote_by! user, false
  end

  def total_votes
    votes.where(upvote: true).size - votes.where(upvote: false).size
  end
end
