module Deleting
  extend ActiveSupport::Concern

  def delete
    deletion
  end

  private

  def deletion
    @model   = controller_name.classify.downcase.to_sym
    @deletable = controller_name.classify.constantize.find(params[:id])

    @deletable.delete_object!(@deletable)

    if @deletable.is_a?(Question)
      redirect_to questions_path
    else
      redirect_to :back
    end
  end
end
