class DocumentsController < ApplicationController
  include Deletables::Destroy
  include Editables::Update

  include Markdown::Process

  def create
    @document = Document.new(create_params)
    @document.document_type = :chunk

    @group = Group.find(params[:id])

    if @document.save

      flash[:notice] = t('document.create.success')
    else
      flash_error_messages_for @document
    end

    redirect_to group_path(@group)
  end

  private

  def create_params
    params.require(:document).permit(:title, :content).merge(group: Group.find(params[:id]))
  end
end
