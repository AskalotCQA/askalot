module Mooc
  class QuestionsController < Shared::QuestionsController
    layout 'mooc/unit'

    def show
      @question = Mooc::Question.find(params[:id])

      authorize! :view, @question

      @labels  = @question.labels
      @answers = @question.ordered_answers
      @answer  = Shared::Answer.new(question: @question)
      @view    = @question.views.create! viewer: current_user

      @question.increment :views_count

      dispatch_event :create, @view, for: @question.watchers
      render 'mooc/units/questions/show'
    end
  end
end
