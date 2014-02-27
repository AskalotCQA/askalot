module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
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
    unless voted_by? user
      votes.create! voter: user, upvote: upvote
    else
      vote = votes.where(voter: user).first

      if vote.upvote == upvote
        vote.destroy
      else
        vote.upvote = upvote
        vote.save!
      end
    end

    update_votes_caches!
  end

  def toggle_voteup_by!(user)
    toggle_vote_by! user, true
  end

  def toggle_votedown_by!(user)
    toggle_vote_by! user, false
  end

  private

  def update_votes_caches!
    positive = votes.positive.size
    negative = votes.negative.size

    self.votes_difference = positive - negative
    self.votes_lb_wsci_bp = Ratain.lb_wsci_bp positive, positive + negative

    self.save!
  end
end
