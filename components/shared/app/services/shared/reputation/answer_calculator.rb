module Shared::Reputation
  class AnswerCalculator
    def reputation(answer, difficulty, min_score, max_score)
      return nil if difficulty.nil?

      utility = utility answer.votes_difference, max_score, min_score, answer.best?

      difficulty + utility unless utility.nil?
    end

    def utility(score, max_score, min_score, best)
      return min_score.nil? || min_score > score ? -1.0 : score.to_f / -min_score if score < 0
      return best ? 1.0 : 0 if score == 0 && (max_score == 0 || max_score.nil? || max_score < score)

      max_score.nil? ? 1.0 : score.to_f / max_score
    end
  end
end
