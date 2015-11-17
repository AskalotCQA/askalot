module Shared::Editables::Update
  extend ActiveSupport::Concern

  include Shared::Events::Dispatch

  def update
    @model    = controller_name.classify.downcase.to_sym
    @editable = ('Shared::' + controller_name.classify).constantize.find(params[:id])

    authorize! :edit, @editable

    @revision = "Shared::#{controller_name.classify}::Revision".constantize.create_revision!(current_user, @editable)

    @editable.assign_attributes(update_params)

    if @editable.changed?
      if @editable.update_attributes_by_revision(@revision)

        if @editable.respond_to? :text
          process_markdown_for @editable do |user|
            dispatch_event :mention, @editable, for: user
          end
        end

        # TODO (jharinek) refactor after making G,D watchable, notifiable
        if @editable.respond_to? :to_question
          dispatch_event :update, @editable, for: @editable.to_question.watchers, anonymous: (@editable.is_a?(Shared::Question) && @editable.anonymous)
        end

        flash[:notice] = t "#{@model}.update.success"
      else
        @revision.destroy!

        # TODO (jharinek) error messages for js request
        flash_error_messages_for @editable
      end
    else
      @revision.destroy!

      flash[:warning] = t "#{@model}.update.unchanged"
    end

    respond_to do |format|
      format.html { redirect_to :back, format: :html }
      format.js   {
        # TODO (jharinek) remove ifs
        if @editable.is_a?(Shared::Question) || @editable.is_a?(Shared::Answer) || @editable.is_a?(Shared::Comment)
          redirect_to question_path(@editable.to_question), format: :js
        else
          redirect_to :back, format: :js
        end
      }
    end
  end
end
