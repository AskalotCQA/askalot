module Deleting
  extend ActiveSupport::Concern

  include Notifications::Notifying

  def destroy
    @model     = controller_name.classify.downcase.to_sym
    @deletable = controller_name.classify.constantize.find(params[:id])

    if @deletable.mark_as_deleted_by! current_user
      notify_about :delete, @deletable, for: @deletable.to_question.watchers

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
