module Mooc
  class QuestionsController < Shared::QuestionsController
    layout 'mooc/unit'

    def show
      @question = Shared::Question.find(params[:id])

      authorize! :view, @question

      @answers = @question.ordered_reactions
      @answer  = Shared::Answer.new(question: @question)
      @view    = @question.views.create! viewer: current_user

      @question.increment :views_count

      @page_url = params[:page_url] || ''

      dispatch_event :create, @view, for: @question.watchers

      render 'mooc/units/questions/show_forum' if @question.mode.forum?
      render 'mooc/units/questions/show' unless @question.mode.forum?
    end
  end
end
