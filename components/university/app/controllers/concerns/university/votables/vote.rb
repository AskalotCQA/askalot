module University::Votables::Vote
  extend ActiveSupport::Concern

  def voteup
    vote true
  end

  def votedown
    vote false
  end

  private

  def vote(positive)
    @model   = controller_name.classify.downcase.to_sym
    @votable = ('University::' + controller_name.classify).constantize.find(params[:id])

    authorize! :vote, @votable

    @vote = @votable.toggle_vote_by!(current_user, positive)

    @votable.votes.reload

    dispatch_event dispatch_event_action_for(@vote), @vote, for: @votable.to_question.watchers

    render 'university/votables/vote', formats: :js
  end
end
