require './scripts/extract_features'

module Recommendation
  class OfflineFeaturesManager

    def answers_count(resource, user)
      return Recommendation.user_answers_older_than_resource(resource, user).count
    end

    def comments_count(resource, user)
      return Recommendation.user_comments_older_than_resource(resource, user).count
    end

    def answers_count_in_last_days(resource, user)
      n_days = 7.day
      return Recommendation.user_answers_older_than_resource(resource, user)
                 .where('created_at > ?', resource.created_at-n_days)
                 .count + Recommendation.user_comments_older_than_resource(resource, user)
                              .where('created_at > ?', resource.created_at-n_days).count
    end

    def recommended_questions_count(resource)
      return 0
    end

    def votes_count(resource, user)
      return Recommendation.user_answers_older_than_resource(resource, user)
                 .sum(:votes_difference) + Recommendation.user_questions_older_than_resource(resource, user)
                                               .sum(:votes_difference)
    end

    def last_answer_before(resource, user)
      last_answer = Recommendation.user_answers_older_than_resource(resource, user)
                        .order(created_at: :desc).limit(1).first
      if last_answer.nil?
        return 0
      else
        return resource.created_at.to_i - last_answer.created_at.to_i
      end
    end


    def is_unit_fresh(resource, category, user)
      # TODO maybe topic or week
      view = user.lists.where(category: category).where('created_at > ?', resource.created_at)
                 .order(created_at: :desc).limit(1).first
      if view.nil?
        return 0
      else
        return resource.created_at.to_i - view.created_at.to_i
      end
    end

    def between_cqa_activity_time(user, resource)
      # Average difference between activities (defined in day range) - without lists events.
      activity_dates = user.activities.unscoped.where.not(resource_type: Shared::List)
                           .where('created_at > ?', resource.created_at)
                           .group_by { |c| c.created_at.to_date }.keys
      if activity_dates.length > 1
        return (activity_dates.each_cons(2).map { |a,b| b-a }.sum() / activity_dates.length).to_f
      else
        return 0
      end
    end

    def between_course_activity_time(user, resource)
      # Average difference between activities (defined in day range) - ONLY lists events.
      activity_dates = user.activities.unscoped.where(resource_type: Shared::List)
                           .where('created_at > ?', resource.created_at)
                           .group_by { |c| c.created_at.to_date }.keys
      if activity_dates.length > 1
        return (activity_dates.each_cons(2).map { |a,b| b-a }.sum() / activity_dates.length).to_f
      else
        return 0
      end
    end

    def avg_cqa_activity(user, resource)
      # Active days divided by days that course is running - without lists events.
      activity_dates = user.activities.unscoped.where.not(resource_type: Shared::List)
                           .where('created_at > ?', resource.created_at)
                           .group_by { |c| c.created_at.to_date }.keys
      total_course_days = (resource.created_at - Shared::User.first.created_at).to_i / 1.day
      if activity_dates.length > 1
        return activity_dates.count.to_f / total_course_days
      else
        return 0
      end
    end

    def avg_course_activity(user, resource)
      # Active days divided by days that course is running - ONLY lists events.
      activity_dates = Shared::List.where(lister_id: user)
                           .where('created_at > ?', resource.created_at)
                           .group_by { |c| c.created_at.to_date }.keys
      total_course_days = (resource.created_at - Shared::User.first.created_at).to_i / 1.day
      if activity_dates.length > 1
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
      return Recommendation.user_questions_older_than_resource(resource, user).count
    end

    def seen_units(resource, category, user)
      total_categories_count = 1
      categories = category
      unless category.leaf?
        # because category.count returns counter of question if leaf
        total_categories_count = category.leaves.count
        categories = category.leaves
      end
      user.lists.where(category: categories).where('created_at > ?', resource.created_at)
          .select('DISTINCT(category_id)').count / total_categories_count.to_f
    end

    def seen_questions_in_category(resource, category, user)
      categories = category.self_and_descendants
      user.views.where('created_at > ?', resource.created_at).joins(:question)
          .where(questions: {category_id: categories})
          .select('DISTINCT(question_id)').count.to_f / categories.sum(:questions_count)
    end


  end
end