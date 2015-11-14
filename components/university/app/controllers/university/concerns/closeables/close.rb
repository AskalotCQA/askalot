module University::Closeables::Close
  extend ActiveSupport::Concern

  def close
    @model = controller_name.classify.downcase.to_sym
    @closeable = controller_name.classify.constantize.find(params[:id])

    authorize! :close, @closeable

    if @closeable.mark_as_closed_by! current_user
      flash[:notice] = t "#{@model}.close.success"
    else
      flash[:error] = t "#{@model}.close.failure"
    end

    if @closeable = controller_name.classify.constantize.find(params[:id])
      respond_to do |format|
        format.html { redirect_to questions_path, format: :html }
        format.js { redirect_to document_questions_path(@closeable.parent), format: :js }
      end
    end
  end
end
