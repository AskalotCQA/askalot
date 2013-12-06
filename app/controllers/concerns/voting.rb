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
    @votable = controller_name.classify.constantize.find(params[:id])

    if voteup
      @votable.toggle_voteup_by!(current_user)
    else
      @votable.toggle_votedown_by!(current_user)
    end

    render :vote
  end
end
