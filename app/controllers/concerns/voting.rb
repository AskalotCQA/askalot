module Voting
  extend ActiveSupport::Concern
  def voteup
    @votable = controller_name.classify.constantize.find(params[:id])

    @votable.toggle_voteup_by!(current_user)

    render :vote
  end

  def votedown
    @votable = controller_name.classify.constantize.find(params[:id])

    @votable.toggle_votedown_by!(current_user)

    render :vote
  end
end
