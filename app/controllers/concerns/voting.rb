module Voting
  extend ActiveSupport::Concern

  def voteup
    vote true
  end

  def votedown
    vote false
  end

  private

  def model
    @model ||= controller_name.classify.constantize
  end

  def vote(voteup)
    @votable = model.find(params[:id])

    @votable.toggle_vote_by!(current_user, voteup)

    render 'vote', formats: :js
  end
end
