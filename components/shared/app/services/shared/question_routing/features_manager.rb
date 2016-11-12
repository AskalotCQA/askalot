module Shared::QuestionRouting
  class FeaturesManager
    N_DAYS = 7.days
    PYTHON_SIM_RETURN_FILE = "recommendation/sim-values.dat"

    # Helpers
    def is_student(user)
      user.assignments.count == 0 && user.role == :student
    end

    def user_answers_older_than_resource(resource, user)
      user.answers.older(resource.created_at)
    end

    def user_questions_older_than_resource(resource, user)
      user.questions.older(resource.created_at)
    end

    def user_comments_older_than_resource(resource, user)
      user.comments.where('created_at < ?', resource.created_at)
    end
    # end Helpers


    def answers_count(resource, user)
      return user_answers_older_than_resource(resource, user).count
    end

    def comments_count(resource, user)
      return user_comments_older_than_resource(resource, user).count
    end

    def answers_count_in_last_days_now(user)
      return user.answers.where('created_at > ?', Time.now-N_DAYS)
                 .count + user.comments.where('created_at > ?', Time.now-N_DAYS).count
    end

    def answers_count_in_last_days(resource, user)
      return user_answers_older_than_resource(resource, user)
                 .where('created_at > ?', resource.created_at-N_DAYS)
                 .count + user_comments_older_than_resource(resource, user)
                              .where('created_at > ?', resource.created_at-N_DAYS).count
    end

    def recommended_questions_count(resource)
      # TODO
      return 0
    end

    def votes_count(resource, user)
      return user_answers_older_than_resource(resource, user)
                 .sum(:votes_difference) + user_questions_older_than_resource(resource, user)
                                               .sum(:votes_difference)
    end

    def last_answer_before(resource, user)
      last_answer = user_answers_older_than_resource(resource, user)
                        .order(created_at: :desc).limit(1).first
      if last_answer.nil?
        return 0
      else
        return resource.created_at.to_i - last_answer.created_at.to_i
      end
    end


    def is_unit_fresh(resource, category, user)
      # TODO maybe topic or week
      # TODO beta testers
      view = user.lists.where(category: category).where('created_at < ?', resource.created_at).first
      if view.nil?
        return 0
      else
        return resource.created_at.to_i - view.created_at.to_i
      end
    end

    def between_cqa_activity_time(user, resource=nil)
      # Average difference between activities (defined in day range) - without lists events.
      activity_dates = user.activities.unscope(where: :resource_type)
                           .where.not(resource_type: Shared::List)
      activity_dates = activity_dates.where('created_at < ?', resource.created_at) if resource
      activity_dates = activity_dates.group_by { |c| c.created_at.to_date }.keys
      if activity_dates.length > 0
        return activity_dates.each_cons(2).map { |a,b| b-a }.sum() / activity_dates.length.to_f
      else
        return 0
      end
    end

    def between_course_activity_time(user, resource=nil)
      # Average difference between activities (defined in day range) - ONLY lists events.
      activity_dates = user.activities.unscope(where: :resource_type)
                           .where(resource_type: Shared::List)
      activity_dates = activity_dates.where('created_at < ?', resource.created_at) if resource
      activity_dates = activity_dates.group_by { |c| c.created_at.to_date }.keys
      if activity_dates.length > 0
        return activity_dates.each_cons(2).map { |a,b| b-a }.sum() / activity_dates.length.to_f
      else
        return 0
      end
    end

    def avg_cqa_activity(user, resource=nil)
      # Active days divided by days that course is running - without lists events.
      if resource
        older_than = resource.created_at
      else
        older_than = Time.now
      end
      activity_dates = user.activities.where('created_at < ?', older_than)
                           .unscope(where: :resource_type).where.not(resource_type: Shared::List)
                           .group_by { |c| c.created_at.to_date }.keys
      total_course_days = (older_than - (Shared::User.first.created_at-1.day)).to_i / 1.day
      if activity_dates.length > 0
        return activity_dates.count.to_f / total_course_days
      else
        return 0
      end
    end

    def avg_course_activity(user, resource=nil)
      # Active days divided by days that course is running - ONLY lists events.
      if resource
        older_than = resource.created_at
      else
        older_than = Time.now
      end
      activity_dates = Shared::List.where(lister_id: user)
                           .where('created_at < ?', older_than)
                           .group_by { |c| c.created_at.to_date }.keys
      total_course_days = (older_than - (Shared::User.first.created_at-1.day)).to_i / 1.day
      if activity_dates.length > 0
        return activity_dates.count.to_f / total_course_days
      else
        return 0
      end
    end

    def rec_ctr()
      return 0
    end

    def user_registration_date(user, resource)
      return resource.created_at.to_f - user.created_at.to_f
    end

    def questions_count(user, resource)
      return user_questions_older_than_resource(resource, user).count
    end

    def seen_units(resource, category, user)
      if category.depth == 1 || category.depth == 2
        # because category.count returns counter of question if leaf
        total_categories_count = category.leaves.count
        categories = category.leaves
        #.select('DISTINCT(category_id)')
        return user.lists.where(category: categories).where('created_at < ?', resource.created_at)
            .count / total_categories_count.to_f
      else
        return 0
      end

    end

    def seen_questions_in_category(resource, category, user)
      categories = category.self_and_descendants
      #.select('DISTINCT(question_id)')
      user.views.where('views.created_at < ?', resource.created_at).joins(:question)
          .where(questions: {category_id: categories})
          .count.to_f / categories.sum(:questions_count)
    end

    def cosine_sim(user, question)
      `python scripts/python/SimilarityQU.py #{question.id} #{user.id}`
    end

    def answers_in_category(user, resource, category)
      return user_answers_older_than_resource(resource, user).in_context(category).count
    end

    def votes_in_category(user, resource, category)
      return user_answers_older_than_resource(resource, user).in_context(category).sum(:votes_difference)
    end

    def get_knowledge(user, resource, category)
      return answers_in_category(user, resource, category) + votes_in_category(user, resource, category)
    end

    def knowledge_gap(answerer, asker, resource, category)
      return get_knowledge(answerer, resource, category) - get_knowledge(asker, resource, category)
    end

    def knowledge_gap_total(answerer, asker, resource)
      answerer_knowledge = answers_count(resource, answerer) + votes_count(resource, answerer)
      asker_knowledge = answers_count(resource, asker) + votes_count(resource, asker)
      return answerer_knowledge - asker_knowledge
    end

    def save_willingness_features(file, resource, category, user, class_id)
      answers_count_f = answers_count(resource, user)
      comments_count_f = comments_count(resource, user)
      answers_count_last_days_f = answers_count_in_last_days(resource, user)
      votes_count_f = votes_count(resource, user)
      last_answer_before_f = last_answer_before(resource, user)
      seen_week_units_f = seen_units(resource, category.parent.parent, user)
      seen_topic_units_f = seen_units(resource, category.parent, user)
      fresh_unit_f = is_unit_fresh(resource, category, user)
      #between_cqa_activity_f = between_cqa_activity_time(user, resource)
      avg_cqa_activity_f = avg_cqa_activity(user, resource)
      #between_course_activity_f = between_course_activity_time(user, resource)
      avg_course_activity_f = avg_course_activity(user, resource)
      seen_week_questions_f = seen_questions_in_category(resource, category.parent.parent, user)
      seen_topic_questions_f = seen_questions_in_category(resource, category.parent, user)
      questions_count_f = questions_count(user, resource)
      user_registration_date_f = user_registration_date(user, resource)
      #rec_questions_count_f = recommended_questions_count(resource)
      #rec_ctr_f = rec_ctr()
      file << "#{class_id} #{answers_count_f} #{comments_count_f} #{answers_count_last_days_f} #{votes_count_f} "\
                  "#{last_answer_before_f} #{seen_week_units_f} #{seen_topic_units_f} #{fresh_unit_f} "\
                  "#{avg_cqa_activity_f} #{avg_course_activity_f} "\
                  "#{seen_week_questions_f} #{seen_topic_questions_f} "\
                  "#{questions_count_f} #{user_registration_date_f}\n"
    end

    def save_expertise_features(file, resource, category, question, user, class_id)
      cosine_sim(user, question)
      cos_sim_f = File.open(PYTHON_SIM_RETURN_FILE, "r") {|f| f.readline}
      answers_in_week_f = answers_in_category(user, resource, category.parent.parent)
      answers_in_topic_f = answers_in_category(user, resource, category.parent)
      votes_in_topic_f = votes_in_category(user, resource, category.parent)
      votes_in_week_f = votes_in_category(user, resource, category.parent.parent)
      #asker_knowledge_f = get_knowledge(question.author, resource, category)
      #answerer_knowledge_f = get_knowledge(user, resource, category)
      knowledge_gap_topic_f = knowledge_gap(user, question.author, resource, category.parent)
      knowledge_gap_week_f = knowledge_gap(user, question.author, resource, category.parent.parent)
      knowledge_gap_total_f = knowledge_gap_total(user, question.author, resource)
      seen_week_units_f = seen_units(resource, category.parent.parent, user)
      seen_topic_units_f = seen_units(resource, category.parent, user)
      if cos_sim_f.to_f > 0
        file << "#{class_id} #{cos_sim_f} #{answers_in_week_f} #{answers_in_topic_f} #{votes_in_topic_f} #{votes_in_week_f} "\
                    "#{knowledge_gap_topic_f} #{knowledge_gap_week_f} #{knowledge_gap_total_f} "\
                    "#{seen_week_units_f} #{seen_topic_units_f}\n"
      end
    end


  end
end