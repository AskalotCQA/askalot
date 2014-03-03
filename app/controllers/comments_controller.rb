class CommentsController < ApplicationController
  include Markdown
  include Notifications::Notifying
  include Notifications::Watching

  before_action :authenticate_user!

  def create
    @commentable = find_commentable
    @question    = @commentable.to_question
    @comment     = Comment.new(comment_params)

    authorize! :comment, @commentable

    process_markdown_for @comment do |user|
      notify_about :'mention-user', @comment, for: user
    end

    if @comment.save
      flash[:notice] = t('comment.create.success')

      register_watching_for @commentable.to_question

      notify_about :'add-comment', @comment, for: @commentable.watchers
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
