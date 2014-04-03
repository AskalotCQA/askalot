module Deletables::Destroy
  extend ActiveSupport::Concern

  include Events::Dispatch

  def destroy
    @model     = controller_name.classify.downcase.to_sym
    @deletable = controller_name.classify.constantize.find(params[:id])

    if @deletable.mark_as_deleted_by! current_user
      #TODO(zbell) do not notify about anonymous questions since user.nick is still exposed in notifications
      dispatch_event :delete, @deletable, for: @deletable.to_question.watchers unless @deletable.to_question.anonymous

      flash[:notice] = t "#{@model}.delete.success"
    else
      flash[:error] = t "#{@model}.delete.failure"
    end

    if @deletable.is_a? Question
      redirect_to questions_path
    else
      redirect_to :back
    end
  end
end
