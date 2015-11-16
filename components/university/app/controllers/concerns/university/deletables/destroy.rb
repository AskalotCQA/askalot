module University::Deletables::Destroy
  extend ActiveSupport::Concern

  include University::Events::Dispatch

  def destroy
    @model     = controller_name.classify.downcase.to_sym
    @deletable = ('University::' + controller_name.classify).constantize.find(params[:id])

    authorize! :delete, @deletable

    if @deletable.mark_as_deleted_by! current_user
      # TODO (jharinek) refactor after making G,D watchable, notifiable
      if @deletable.respond_to? :to_question
        dispatch_event :delete, @deletable, for: @deletable.to_question.watchers, anonymous: (@deletable.is_a?(University::Question) && @deletable.anonymous)
      end

      flash[:notice] = t "#{@model}.delete.success"
    else
      flash[:error] = t "#{@model}.delete.failure"
    end

    # TODO (zbell) remove ifs, add abstract protected method call instead
    if @deletable.is_a? University::Question
      respond_to do |format|
        format.html { redirect_to questions_path, format: :html }
        format.js   { redirect_to document_questions_path(@deletable.parent), format: :js }
      end
    elsif @deletable.is_a? University::Group
      redirect_to groups_path
    else
      respond_to do |format|
        format.html { redirect_to :back, format: :html }
        format.js   {
          # TODO (jharinek) remove ifs
          if @deletable.is_a?(University::Answer) || @deletable.is_a?(University::Comment)
            redirect_to question_path(@deletable.to_question), format: :js
          else
            redirect_to :back, format: :js
          end
        }
      end
    end
  end
end
