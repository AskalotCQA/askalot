require './scripts/extract_features'
require './scripts/offline_features_manager'

$output_file = File.open("/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/willingness-train.dat", "w")

@manager = Recommendation::OfflineFeaturesManager.new

def build_features(resource, category, user, class_id)
  answers_count_f = @manager.answers_count(resource, user)
  comments_count_f = @manager.comments_count(resource, user)
  answers_count_last_days_f = @manager.answers_count_in_last_days(resource, user)
  votes_count_f = @manager.votes_count(resource, user)
  last_answer_before_f = @manager.last_answer_before(resource, user)
  seen_week_categories_f = @manager.seen_units(resource, category.parent.parent, user)
  seen_topic_categories_f = @manager.seen_units(resource, category.parent, user)
  fresh_unit_f = @manager.is_unit_fresh(resource, category, user)
  between_cqa_activity_f = @manager.between_cqa_activity_time(user, resource)
  avg_cqa_activity_f = @manager.avg_cqa_activity(user, resource)
  between_course_activity_f = @manager.between_course_activity_time(user, resource)
  avg_course_activity_f = @manager.avg_course_activity(user, resource)
  seen_week_questions_f = @manager.seen_questions_in_category(resource, category.parent.parent, user)
  seen_topic_questions_f = @manager.seen_questions_in_category(resource, category.parent, user)
  questions_count_f = @manager.questions_count(user, resource)
  user_registration_date_f = @manager.user_registration_date(user, resource)
  rec_questions_count_f = @manager.recommended_questions_count(resource)
  rec_ctr_f = @manager.rec_ctr()
  $output_file << "#{class_id} #{answers_count_f} #{comments_count_f} #{answers_count_last_days_f} #{votes_count_f} "\
                  "#{last_answer_before_f} #{seen_week_categories_f} #{seen_topic_categories_f} #{fresh_unit_f} "\
                  "#{between_cqa_activity_f} #{avg_cqa_activity_f} #{between_course_activity_f} #{avg_course_activity_f} "\
                  "#{seen_week_questions_f} #{seen_topic_questions_f} "\
                  "#{questions_count_f} #{user_registration_date_f} #{rec_questions_count_f} #{rec_ctr_f}\n"
end

answers = Shared::Answer.all
answers.each do |answer|
  next unless Recommendation.is_student(answer.author)
  build_features(answer, answer.question.category, answer.author, 1)
end

comments = Shared::Comment.all
comments.each do |comment|
  next unless Recommendation.is_student(comment.author)
  category = comment.commentable.try(:category) || comment.commentable.question.category
  build_features(comment, category, comment.author, 1)
end

views = Shared::View.all
views.each do |view|
  next unless Recommendation.is_student(view.viewer)
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