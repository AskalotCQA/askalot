module Shared::Activities
  module ActivitiesFilter
    extend self

    def comments_for_questions(questions)
      Shared::Comment.for('Shared::Question').where(commentable_id: questions.pluck(:id))
    end

    def comments_for_answers(answers)
      Shared::Comment.for('Shared::Answer').where(commentable_id: answers.pluck(:id))
    end

    def watched_questions(user)
      Shared::Question.in_context(categories_in_watched_contexts(user).pluck(:id))
    end

    def watched_answers(user)
      Shared::Answer.in_context(categories_in_watched_contexts(user).pluck(:id))
    end

    def categories_in_watched_contexts(user)
      Shared::Category.all_in_contexts(user.watchings.of('Shared::Category').pluck(:watchable_id))
    end

    def activities_for_followed_categories(user)
      categories           = categories_in_watched_contexts(user).includes(:questions, :answers, questions: [:comments, :evaluations], answers: [:comments, :evaluations, :labelings])
      questions            = categories.map(&:questions).flatten
      answers              = questions.map(&:answers).flatten
      answer_comments      = answers.map(&:comments).flatten
      question_comments    = questions.map(&:comments).flatten
      question_evaluations = questions.map(&:evaluations).flatten
      answers_evaluations  = answers.map(&:evaluations).flatten
      answers_labelings    = answers.map(&:labelings).flatten

      query = '('
      query += "(resource_type = 'Shared::Question' AND resource_id in ( #{questions.map{|e| e.id}.join(",")})) OR "
      query += "(resource_type = 'Shared::Answer' AND resource_id in (#{answers.map{|e| e.id}.join(",")})) OR "
      query += "(resource_type = 'Shared::Comment' AND resource_id in (#{[answer_comments + question_comments].flatten.map{|e| e.id}.join(",")})) OR "
      query += "(resource_type = 'Shared::Evaluation' AND resource_id in (#{[question_evaluations + answers_evaluations].flatten.map{|e| e.id}.join(",")})) OR "
      query += "(resource_type = 'Shared::Labeling' AND resource_id in (#{answers_labelings.map{|e| e.id}.join(",")}))"
      query += ')'

      Shared::Activity.where(query)
    end
  end
end
