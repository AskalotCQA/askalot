module University
  class QuestionsController < Shared::QuestionsController
    def document_index
      @document  = University::Document.find(params[:document_id])
      @questions = @document.questions.order(touched_at: :desc)

      @questions = @questions.page(params[:page]).per(20)

      initialize_polling
    end
  end
end
