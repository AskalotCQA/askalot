module Shared::Editables::Update
  extend ActiveSupport::Concern

  include Shared::Events::Dispatch

  def update
    @model    = controller_name.classify.downcase.to_sym
    @editable = controller_path.classify.constantize.find(params[:id])
    @engine   = controller_path.classify.deconstantize

    authorize! :edit, @editable

    @revision = "#{@engine}::#{controller_name.classify}::Revision".constantize.create_revision!(current_user, @editable)

    if params[:attachments]
      params[:attachments].each { |a| @editable.attachments.new(file: a, author: current_user) }

      if @editable.save
        flash[:notice] = t "attachment.create.success"
      else
        flash_error_messages_for @editable
      end
    end

    @editable.assign_attributes(update_params)

    if @editable.changed?
      old_category_id = @editable.changes['category_id'].first if @editable.changed.include?('category_id')

      if @editable.update_attributes_by_revision(@revision)

        if @editable.respond_to? :text
          process_markdown_for @editable do |user|
            dispatch_event :mention, @editable, for: user
          end
        end

        # TODO (jharinek) refactor after making G,D watchable, notifiable
        if @editable.respond_to? :to_question
          watchers = @editable.to_question.watchers

          if @editable.is_a?(Shared::Question)
            watchers += @editable.parent_watchers
            watchers += Shared::Category.find(old_category_id).parent_watchers if defined?(old_category_id) && old_category_id
          end

          dispatch_event :update, @editable, for: watchers, anonymous: ([Shared::Question, Shared::Answer, Shared::Comment].member?(@editable.class) && @editable.anonymous)
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
      format.js {
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
