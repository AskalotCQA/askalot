module Shared::Dashboard
  module DashboardService
    extend self

    def dashboard_questions(context, user)
      Shared::Question.in_context(context).where.not(author: user)
    end

    def dashboard_answers(context, user)
      Shared::Answer.in_context(context).where.not(author: user)
    end

    def dashboard_question_comments(questions, user)
      Shared::Activities::ActivitiesFilter.comments_for_questions(questions).where.not(author: user)
    end

    def dashboard_answer_comments(answers, user)
      Shared::Activities::ActivitiesFilter.comments_for_answers(answers).where.not(author: user)
    end

    def dashboard_questions_watched(user)
      Shared::Activities::ActivitiesFilter.watched_questions(user).where.not(author: user)
    end

    def dashboard_answers_watched(user)
      Shared::Activities::ActivitiesFilter.watched_answers(user).where.not(author: user)
    end

    def fresh(query, user)
      query.where("#{query.table_name}.created_at >= ?", user.dashboard_last_sign_in_at)
    end

    def dashboard_count(query, user)
      fresh(query, user).count
    end

    def questions_by_dashboard_param(from_dashboard, context, user)
      case from_dashboard
      when :new_questions
        questions = dashboard_questions(context, user)

        fresh(questions, user)
      when :new_answers
        context_answers = dashboard_answers(context, user)
        context_answers = fresh(context_answers, user)

        questions_by_answers(context_answers)
      when :new_comments
        context_questions = dashboard_questions(context, user)
        context_answers = dashboard_answers(context, user)

        context_questions_comments = fresh(dashboard_question_comments(context_questions, user), user)
        context_answers_comments = fresh(dashboard_answer_comments(context_answers, user), user)

        questions_by_comments(context_questions_comments, context_answers_comments)
      when :new_questions_in_watched_categories
        context_questions = dashboard_questions_watched(user)

        fresh(context_questions, user)
      when :new_answers_in_watched_categories
        context_answers = dashboard_answers_watched(user)
        context_answers = fresh(context_answers, user)

        questions_by_answers(context_answers)
      when :new_comments_in_watched_categories
        context_questions = dashboard_questions_watched(user)
        context_answers = dashboard_answers_watched(user)

        context_questions_comments = fresh(dashboard_question_comments(context_questions, user), user)
        context_answers_comments = fresh(dashboard_answer_comments(context_answers, user), user)

        questions_by_comments(context_questions_comments, context_answers_comments)
      end
    end

    def questions_by_answers(answers)
      Shared::Question.where(id: answers.pluck(:question_id))
    end

    def questions_by_comments(question_comments, answer_comments)
      answers = Shared::Answer.where(id: answer_comments.pluck(:commentable_id))

      Shared::Question.where(id: question_comments.pluck(:commentable_id) + answers.pluck(:question_id))
    end
  end
end
