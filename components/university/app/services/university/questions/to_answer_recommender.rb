module University::Questions
  module ToAnswerRecommender
    extend self

    def next
      University::Question.unanswered.random.first || University::Question.random.first
    end
  end
end
