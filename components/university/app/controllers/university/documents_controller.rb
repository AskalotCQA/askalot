module University
class DocumentsController < ApplicationController
  include Shared::Deletables::Destroy
  include Shared::Editables::Update
  include Shared::Watchables::Watch

  include Shared::Markdown::Process

  def create
    @group    = University::Group.find(params[:group_id])
    @document = University::Document.new(create_params)

    if @document.save
      flash[:notice] = t('document.create.success')
    else
      flash_error_messages_for @document
    end

    redirect_to group_path(@group)
  end

  private

  def create_params
    params.require(:document).permit(:title, :text).merge(group: @group, author: current_user)
  end

  def update_params
    params.require(:document).permit(:title, :text)
  end

  protected

  def destroy_callback(deletable)
    respond_to do |format|
      format.html { redirect_to :back, format: :html }
      format.js   { redirect_to :back, format: :js }
    end
  end
end
end
