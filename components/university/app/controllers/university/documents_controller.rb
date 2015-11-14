module University
class DocumentsController < ApplicationController
  include Deletables::Destroy
  include Editables::Update
  include Watchables::Watch

  include Markdown::Process

  def create
    @group    = Group.find(params[:group_id])
    @document = Document.new(create_params)

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
end
end
