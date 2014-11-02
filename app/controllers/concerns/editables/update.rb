module Editables::Update
  extend ActiveSupport::Concern

  include Events::Dispatch

  def update
    @model    = controller_name.classify.downcase.to_sym
    @editable = controller_name.classify.constantize.find(params[:id])

    authorize! :edit, @editable

    @revision = "#{controller_name.classify}::Revision".constantize.create_revision!(current_user, @editable)

    @editable.assign_attributes(update_params)

    if @editable.changed?
      if @editable.update_attributes_by_revision(@revision)

        attribute = { attribute: :@editable.is_a?(Document) ? :content : :text }
        process_markdown_for @editable, attribute do |user|
          dispatch_event :mention, @editable, for: user
        end

        dispatch_event :update, @editable, for: @editable.to_question.watchers, anonymous: (@editable.is_a?(Question) && @editable.anonymous)

        flash[:notice] = t "#{@model}.update.success"
      else
        @revision.destroy!

        flash_error_messages_for @editable
      end
    else
      @revision.destroy!

      flash[:warning] = t "#{@model}.update.unchanged"
    end

    respond_to do |format|
      format.html { redirect_to :back, format: :html }
      format.js   { redirect_to :back, format: :js }
    end
  end
end
