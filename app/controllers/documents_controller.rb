class DocumentsController
  def new
    @document = Document.new
  end

  def create
    @document = Document.new(create_params)

    if @document.save

    else

    end
  end

  private
  def create_params
    params.require(:document).permit(:title, :content)
  end
end
