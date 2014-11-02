module Deletables::Destroy
  extend ActiveSupport::Concern

  include Events::Dispatch

  def destroy
    @model     = controller_name.classify.downcase.to_sym
    @deletable = controller_name.classify.constantize.find(params[:id])

    authorize! :delete, @deletable

    if @deletable.mark_as_deleted_by! current_user
      dispatch_event :delete, @deletable, for: @deletable.to_question.watchers, anonymous: (@deletable.is_a?(Question) && @deletable.anonymous)

      flash[:notice] = t "#{@model}.delete.success"
    else
      flash[:error] = t "#{@model}.delete.failure"
    end

    if @deletable.is_a? Question
      respond_to do |format|
        format.html { redirect_to questions_path, format: :html }
        format.js   { redirect_to document_questions_path(@deletable.parent), format: :js }
      end
    else
      respond_to do |format|
        format.html { redirect_to :back, format: :html }
        format.js   { redirect_to :back, format: :js }
      end
    end
  end
end
