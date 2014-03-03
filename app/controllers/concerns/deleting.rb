module Deleting
  extend ActiveSupport::Concern

  def delete
    @model = controller_name.classify.downcase.to_sym
    @deletable = controller_name.classify.constantize.find(params[:id])

    if @deletable.mark_as_deleted!(@deletable)
      flash[:notice] = t("#{@model}.delete.success")
    else
      flash_error_messages_for @deletable
    end

    if @deletable.is_a?(Question)
      redirect_to questions_path
    else
      redirect_to :back
    end
  end
end
