module Votables::Vote
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

    authorize! :vote, @votable

    @vote = @votable.toggle_vote_by!(current_user, voteup)

    @votable.votes.reload

    dispatch_event dispatch_event_action_for(@vote), @vote, for: @votable.to_question.watchers

    render 'votables/vote', formats: :js
  end
end
