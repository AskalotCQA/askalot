require './scripts/extract_features'

$output_file = File.open("/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-train.dat", "w")



def answers_count(resource, user)
  return ExtractFeatures.user_answers_older_than_resource(resource, user).count
end

def comments_count(resource, user)
  return ExtractFeatures.user_comments_older_than_resource(resource, user).count
end

def answers_count_in_last_days(resource, user)
  n_days = 7.day
  return ExtractFeatures.user_answers_older_than_resource(resource, user)
             .where('created_at > ?', resource.created_at-n_days)
             .count + ExtractFeatures.user_comments_older_than_resource(resource, user)
                          .where('created_at > ?', resource.created_at-n_days).count
end

def recommended_questions_count(resource)
  return 0
end

def votes_count(resource, user)
  return ExtractFeatures.user_answers_older_than_resource(resource, user)
               .sum(:votes_difference) + ExtractFeatures.user_questions_older_than_resource(resource, user)
                                           .sum(:votes_difference)
end

def last_answer_before(resource, user)
  last_answer = ExtractFeatures.user_answers_older_than_resource(resource, user)
                    .order(created_at: :desc).limit(1).first
  if last_answer.nil?
    return 0
  else
    return resource.created_at.to_f - last_answer.created_at.to_f
  end
end


def is_unit_fresh(resource, category, user)
  # TODO maybe topic or week
  view = user.lists.where(category: category).where('created_at > ?', resource.created_at)
                  .order(created_at: :desc).limit(1).first
  if view.nil?
    return 0
  else
    return resource.created_at.to_f - view.created_at.to_f
  end
end

def avg_activity(user, resource)
  # Average difference between activities (defined in day range).
  activity_dates = user.activities.order(created_at: :desc).where('created_at > ?', resource.created_at)
                       .group_by { |c| c.created_at.to_date }.keys
  if activity_dates.length > 1
    return (activity_dates.each_cons(2).map { |a,b| a-b }.sum() / activity_dates.length).to_f
  else
    return 0
  end
end

def total_activity(user, resource)
  # Active days divided by days that course is running.
  activity_dates = user.activities.order(created_at: :desc).where('created_at > ?', resource.created_at)
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
  return ExtractFeatures.user_questions_older_than_resource(resource, user).count
end

def build_features(resource, category, user, class_id)
  answers_count_f = answers_count(resource, user)
  comments_count_f = comments_count(resource, user)
  answers_count_last_days_f = answers_count_in_last_days(resource, user)
  votes_count_f = votes_count(resource, user)
  last_answer_before_f = last_answer_before(resource, user)
  seen_week_categories_f = ExtractFeatures.portion_of_seen_categories(resource, category.parent.parent, user)
  seen_topic_categories_f = ExtractFeatures.portion_of_seen_categories(resource, category.parent, user)
  fresh_unit_f = is_unit_fresh(resource, category, user)
  avg_activity_f = avg_activity(user, resource)
  total_activity_f = total_activity(user, resource)
  questions_count_f = questions_count(user, resource)
  user_registration_date_f = user_registration_date(user, resource)
  rec_questions_count_f = recommended_questions_count(resource)
  rec_ctr_f = rec_ctr()
  $output_file << "#{class_id} #{answers_count_f} #{comments_count_f} #{answers_count_last_days_f} #{votes_count_f} "\
                  "#{last_answer_before_f} #{seen_week_categories_f} #{seen_topic_categories_f} #{fresh_unit_f} "\
                  "#{avg_activity_f} #{total_activity_f} "\
                  "#{questions_count_f} #{user_registration_date_f} #{rec_questions_count_f} #{rec_ctr_f}\n"
end

answers = Shared::Answer.all
answers.each do |answer|
  next unless ExtractFeatures.is_student(answer.author)
  build_features(answer, answer.question.category, answer.author, 1)
end

comments = Shared::Comment.all
comments.each do |comment|
  next unless ExtractFeatures.is_student(comment.author)
  category = comment.commentable.try(:category) || comment.commentable.question.category
  build_features(comment, category, comment.author, 1)
end

views = Shared::View.all
views.each do |view|
  next unless ExtractFeatures.is_student(view.viewer)
  # not answered by viewer AND no vote for question AND no vote for answers
  if view.question.answers.find_by(author: view.viewer).nil? &&
      view.question.votes.by(view.viewer).count == 0 &&
      Shared::Vote.where(votable_type: Shared::Answer, voter_id: view.viewer,
                         votable_id: view.question.answers).count == 0
    build_features(view, view.question.category, view.viewer, 0)
  else
    puts 'Filtered - Class 0'
  end
end

$output_file.close()