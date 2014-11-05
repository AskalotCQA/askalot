class DocumentsController < ApplicationController
  include Deletables::Destroy
  include Editables::Update
  include Watchables::Watch

  include Markdown::Process

  def create
    @document = Document.new(create_params)
    @group    = Group.find(params[:id])

    if @document.save
      flash[:notice] = t('document.create.success')
    else
      flash_error_messages_for @document
    end

    redirect_to group_path(@group)
  end

  private

  def create_params
    params.require(:document).permit(:title, :content).merge(group: Group.find(params[:id]), author: current_user)
  end

  def update_params
    params.require(:document).permit(:title, :text)
  end
end
