module University
class CommentsController < ApplicationController
  include University::Deletables::Destroy
  include University::Editables::Update

  include University::Events::Dispatch
  include University::Markdown::Process
  include University::Watchings::Register

  before_action :authenticate_user!

  def create
    @commentable = find_commentable
    @question    = @commentable.to_question
    @comment     = University::Comment.new(create_params)

    authorize! :comment, @commentable

    if @comment.save
      process_markdown_for @comment do |user|
        dispatch_event :mention, @comment, for: user
      end

      dispatch_event :create, @comment, for: @question.watchers
      register_watching_for @question

      flash[:notice] = t('comment.create.success')
    else
      flash_error_messages_for @comment
    end

    respond_to do |format|
      format.html { redirect_to question_path(@question), format: :html }
      format.js   { redirect_to question_path(@question), format: :js }
    end
  end

  private

  def find_commentable
    [:question_id, :answer_id].each { |id| return ('University::' + id.to_s[0..-4].classify).constantize.find(params[id]) if params[id] }
  end

  def create_params
    params.require(:comment).permit(:text).merge(commentable: @commentable, author: current_user)
  end

  def update_params
    params.require(:comment).permit(:text)
  end
end
end
