module Shared::Questions
  module ToAnswerRecommender
    extend self

    def next
      Shared::Question.in_context(Shared::Context::Manager.current_context_id).unanswered.random.first || Shared::Question.in_context(Shared::Context::Manager.current_context_id).random.first
    end
  end
end
