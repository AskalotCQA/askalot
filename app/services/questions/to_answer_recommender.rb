module Questions
  module ToAnswerRecommender
    extend self

    def next
      Question.unanswered.random.first || Question.random.first
    end
  end
end
