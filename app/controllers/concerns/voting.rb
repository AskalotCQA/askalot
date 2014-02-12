module Voting
  extend ActiveSupport::Concern

  def voteup
    vote true
  end

  def votedown
    vote false
  end

  private

  def vote(voteup)
    @model   = controller_name.classify.downcase.to_sym
    @votable = controller_name.classify.constantize.find(params[:id])

    @votable.toggle_vote_by!(current_user, voteup)
    @votable.votes.reload

    render 'votables/vote', formats: :js
  end
end
