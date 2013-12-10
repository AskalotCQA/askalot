module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable
    has_many :voters, through: :votes, source: :voter
  end

  def toggle_vote_by!(voter, upvote)
    return votes.create! voter: voter, upvote: upvote unless voted_by? voter

    vote = votes.where(voter: voter).first

    return vote.destroy if vote.upvote == upvote

    vote.upvote = upvote
    vote.save!
  end

  def toggle_voteup_by!(voter)
    toggle_vote_by! voter, true
  end

  def toggle_votedown_by!(voter)
    toggle_vote_by! voter, false
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

  def total_votes
    votes.where(upvote: true).size - votes.where(upvote: false).size
  end
end
