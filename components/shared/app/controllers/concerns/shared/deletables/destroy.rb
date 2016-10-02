module Shared::Deletables::Destroy
  extend ActiveSupport::Concern

  include Shared::Events::Dispatch

  def destroy
    @model     = controller_name.classify.downcase.to_sym
    @deletable = controller_path.classify.constantize.find(params[:id])

    authorize! :delete, @deletable

    if @deletable.mark_as_deleted_by! current_user
      # TODO (jharinek) refactor after making G,D watchable, notifiable
      if @deletable.respond_to? :to_question
        dispatch_event :delete, @deletable, for: @deletable.to_question.watchers, anonymous: ([Shared::Question, Shared::Answer, Shared::Comment].member?(@deletable.class) && @deletable.anonymous)
      end

      flash[:notice] = t "#{@model}.delete.success"
    else
      flash[:error] = t "#{@model}.delete.failure"
    end

    destroy_callback @deletable
  end

  def destroy_callback
    raise NotImplementedError, "Subclasses must define 'destroy_callback'."
  end
end
