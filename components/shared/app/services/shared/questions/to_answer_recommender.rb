module Shared::Questions
  module ToAnswerRecommender
    extend self

    def next
      Shared::Question.in_context(Shared::Context::Manager.current_context).unanswered.random.first || Shared::Question.in_context(Shared::Context::Manager.current_context).random.first
    end
  end
end
