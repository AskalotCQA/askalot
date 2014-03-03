class CommentsController < ApplicationController
  include Concerns::Watching

  before_action :authenticate_user!

  def create
    @commentable = find_commentable
    @question    = @commentable.to_question
    @comment     = Comment.new(comment_params)

    authorize! :comment, @commentable

    if @comment.save
      flash[:notice] = t('comment.create.success')

      register_watching_for @commentable.to_question
    else
      flash_error_messages_for @comment
    end

    redirect_to question_path(@question)
  end

  private

  def find_commentable
    [:question_id, :answer_id].each { |id| return id.to_s[0..-4].classify.constantize.find(params[id]) if params[id] }
  end

  def comment_params
    params.require(:comment).permit(:text).merge(commentable: @commentable, author: current_user)
  end
end
