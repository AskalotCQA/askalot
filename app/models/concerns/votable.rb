module Votable extend ActiveSupport::Concern
  included do
    has_many :votes, as: :votable
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
