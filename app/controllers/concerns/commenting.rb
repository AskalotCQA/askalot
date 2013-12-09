# TODO (zbell) remove concern, refactor back into comments_controllers
#

module Commenting
  extend ActiveSupport::Concern

  def comment
    @commentable = controller_name.classify.constantize.find(params[:id])
    @comment     = Comment.new(comment_params)

    if @comment.save
      flash.now[:notice] = t('comment.create.success')
    else
      flash_error_messages_for @comment
    end

    # TODO(grznar) refactor
    render 'questions/show'
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(commentable: @commentable, author: current_user)
  end
end
