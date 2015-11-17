module Shared::Reputation
  class QuestionCalculator
    def reputation(question, time, score)
      difficulty = difficulty question, time
      utility    = utility question, score

      difficulty + utility unless difficulty.nil? || utility.nil?
    end

    def time(question, answer)
      return (answer.created_at - question.created_at).to_f.round(6) unless answer.nil?

      (question.answers.order(:created_at).first.created_at - question.created_at).to_f.round(6) unless question.answers.empty?
    end

    def difficulty(question, time)
      return nil if time.nil?

      max_values        = max_tag_times question
      difficulty_values = []

      return nil if max_values.nil?

      max_avg = max_values.inject { |sum, el| sum + el }.to_f / max_values.size

      return time == 0 ? 1.0 : 0.0 if max_avg == 0.0

      max_values.each_with_index do |m, i|
        difficulty_values[i] = time / m.to_f
      end

      difficulty_values.inject { |sum, el| sum + el }.to_f / difficulty_values.size
    end

    def utility(question, score)
      min_or_max        = score < 0 ? :min : :max
      min_or_max_values = tag_scores question, min_or_max
      utility_values    = []

      return nil if min_or_max_values.nil?

      min_or_max_avg = min_or_max_values.inject { |sum, el| sum + el }.to_f / min_or_max_values.size

      return score == 0 ? 1.0 : 0.0 if min_or_max_avg == 0

      min_or_max_values.each_with_index do |m, i|
        utility_values[i] = m == 0 ? 1.0 : score / m.to_f
      end

      avg = utility_values.inject { |sum, el| sum + el }.to_f / utility_values.size

      score < 0 ? -avg : avg
    end

    private

    def tag_scores(question, min_or_max)
      values = []

      question.tags.each do |t|
        tag_score = min_or_max == :min ? t.min_votes_difference : t.max_votes_difference

        next if tag_score.nil?

        values << tag_score
      end

      values.size > 0 ? values : nil
    end

    def max_tag_times(question)
      values = []

      question.tags.each do |t|
        next if t.max_time.nil?

        values << t.max_time
      end

      values.size > 0 ? values : nil
    end
  end
end
