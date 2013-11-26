class CommentsController < ApplicationController
  def index
    @commentable = find_commentable
    @comments = @commentable.comments
  end

  def create
    @commentable = find_commentable
    @question    = Question.find params[:question_id]
    @author      = @question.author
    @comment     = @commentable.comments.build(comment_params)

    if comment.save
      flash[:notice] = t('comment.create.success')

      redirect_to question_path(@question)
    else
      flash_error_messages_for comment

      render 'questions/show'
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:text).merge(author: current_user)
  end

  def find_commentable
    params.each do |name, value|
      if name =~ /(.+)_id$/
        return $1.classify.constantize.find(value)
      end
    end
    nil
  end
end
