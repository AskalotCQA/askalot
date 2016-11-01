namespace :recommendation do
  desc 'Update features for question recommendation'
  task update_features: :environment do
    @manager = Recommendation::OnlineFeaturesManager.new
    #compute_seen_units()
    compute_activity()
    # TODO rec_counr, rec_ctr
  end
end

def compute_seen_units()
  users = Shared::User.where('views_count > 0')
  categories = Shared::Category.where(depth: [1, 2])
  users.each do |user|
    categories.each do |category|
      value = @manager.seen_units(category, user)
      Shared::User::Profile.of('SeenUnits').where(user: user,
                                                  targetable: category,
                                                  property: 'SeenUnits')
          .first_or_create.update(value: value) unless value == 0
    end
  end
end

def compute_activity()
  users = Shared::User.where('views_count > 0')
  users.each do |user|
    #between_cqa_activity = @manager.between_cqa_activity_time(user)
    #user.profiles.get_feature('BetweenCqaActivity').update(value: )
    avg_cqa_activity = @manager.avg_cqa_activity(user)
    user.profiles.get_feature('AvgCqaActivity').update(value: avg_cqa_activity) if avg_cqa_activity > 0
    #user.profiles.get_feature('BetweenCourseActivity').update(value: @manager.between_course_activity_time(user))
    avg_course_act = @manager.avg_course_activity(user)
    user.profiles.get_feature('AvgCourseActivity').update(value: avg_course_act) if avg_course_act > 0
    recent_answers_count = @manager.answers_count_in_last_days(user)
    user.profiles.get_feature('RecentAnswersCount').update(value: recent_answers_count) if recent_answers_count > 0
  end
end
