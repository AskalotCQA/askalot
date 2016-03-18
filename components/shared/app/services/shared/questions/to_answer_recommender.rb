module Shared::Questions
  module ToAnswerRecommender
    extend self

    def next
      Shared::Question.unanswered.random.first || Shared::Question.random.first
    end
  end
end
