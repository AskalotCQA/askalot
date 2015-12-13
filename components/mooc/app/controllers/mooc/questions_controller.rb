module Mooc
  class QuestionsController < Shared::QuestionsController
    load_and_authorize_resource

    layout 'mooc/unit'

    def show
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
