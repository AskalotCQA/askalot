module Mooc
  class QuestionsController < Shared::QuestionsController
    layout 'mooc/unit'

    def show
      super
      render 'mooc/units/questions/show'
    end
  end
end
