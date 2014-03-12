module Editing
  extend ActiveSupport::Concern

  include Notifications::Notifying

  def update
    @model    = controller_name.classify.downcase.to_sym
    @editable = controller_name.classify.constantize.find(params[:id])

    authorize! :edit, @editable

    @revision = "#{controller_name.classify}Revision".constantize.create_revision!(current_user, @editable)

    @editable.assign_attributes(update_params)

    if @editable.changed?
      if @editable.save && @editable.update_attributes_by_revision(@revision)
        notify_about "update-#{@model}", @editable, for: @editable.watchers

        flash[:notice] = t "#{@model}.update.success"
      else
        @revision.destroy!

        flash_error_messages_for @editable
      end
    else
      @revision.destroy!

      flash[:warning] = t "#{@model}.update.unchanged"
    end

    redirect_to :back
  end
end
