module Shared
class CommentsController < ApplicationController
  include Shared::Deletables::Destroy
  include Shared::Editables::Update

  include Shared::Events::Dispatch
  include Shared::Markdown::Process
  include Shared::Watchings::Register

  before_action :authenticate_user!

  def create
    @commentable = find_commentable
    @question    = @commentable.to_question
    @comment     = Shared::Comment.new(create_params)

    authorize! :comment, @commentable

    if @comment.save
      process_markdown_for @comment do |user|
        dispatch_event :mention, @comment, for: user
      end

      dispatch_event :create, @comment, for: @question.watchers, anonymous: @comment.anonymous
      register_watching_for @question

      flash[:notice] = t('comment.create.success')
    else
      flash_error_messages_for @comment
    end

    # TODO (filip jandura) move logic to mooc module
    return redirect_to mooc.unit_question_path(unit_id: @question.category.id, id: @question.id) if params[:unit_view]
    return redirect_to university.third_party_question_path(hash: @question.category.parent.third_party_hash, name: @question.category.name, id: @question.id) if request.referrer.include? 'third_party'

    respond_to do |format|
      format.html { redirect_to question_path(@question), format: :html }
      format.js   { redirect_to question_path(@question), format: :js }
    end
  end

  private

  def find_commentable
    [:question_id, :answer_id].each { |id| return ('Shared::' + id.to_s[0..-4].classify).constantize.find(params[id]) if params[id] }
  end

  def create_params
    params.require(:comment).permit(:text, :anonymous).merge(commentable: @commentable, author: current_user)
  end

  def update_params
    params.require(:comment).permit(:text)
  end

  protected

  def destroy_callback(deletable)
    respond_to do |format|
      format.html { redirect_to :back, format: :html }
      format.js   { redirect_to question_path(@deletable.to_question), format: :js }
    end
  end
end
end
