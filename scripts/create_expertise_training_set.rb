require './scripts/extract_features'

$output_file = File.open("/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/expertise-train.dat", "w")
$input_filename = "/media/dmacjam/Data disc1/git/Askalot-dev/askalot/tmp/return-values.dat"

@manager = Recommendation::OfflineFeaturesManager.new

def cosine_sim(user, question)
  `python scripts/python/SimilarityQU.py #{question.id} #{user.id}`
end

def update_bow(answer)
  `python scripts/python/UpdateUserProfile.py #{answer.id}`
end

def answers_in_category(user, resource, category)
  return @manager.user_answers_older_than_resource(resource, user).in_context(category).count
end

def votes_in_category(user, resource, category)
  return @manager.user_answers_older_than_resource(resource, user).in_context(category).sum(:votes_difference)
end

def get_knowledge(user, resource, category)
  return answers_in_category(user, resource, category) + votes_in_category(user, resource, category)
end

def knowledge_gap(answerer, asker, resource, category)
  return get_knowledge(answerer, resource, category) - get_knowledge(asker, resource, category)
end

def knowledge_gap_total(answerer, asker, resource)
  answerer_knowledge = @manager.answers_count(resource, answerer) + @manager
                                                                        .votes_count(resource, answerer)
  asker_knowledge = @manager.answers_count(resource, asker) + @manager
                                                                     .votes_count(resource, asker)
  return answerer_knowledge - asker_knowledge
end

def build_features(resource, category, question, user, class_id)
  cosine_sim(user, question)
  cos_sim_f = File.open($input_filename, "r") {|f| f.readline}
  answers_in_week_f = answers_in_category(user, resource, category.parent.parent)
  answers_in_topic_f = answers_in_category(user, resource, category.parent)
  votes_in_topic_f = votes_in_category(user, resource, category.parent)
  votes_in_week_f = votes_in_category(user, resource, category.parent.parent)
  #asker_knowledge_f = get_knowledge(question.author, resource, category)
  #answerer_knowledge_f = get_knowledge(user, resource, category)
  knowledge_gap_topic_f = knowledge_gap(user, question.author, resource, category.parent)
  knowledge_gap_week_f = knowledge_gap(user, question.author, resource, category.parent.parent)
  knowledge_gap_total_f = knowledge_gap_total(user, question.author, resource)
  seen_week_units_f = @manager.seen_units(resource, category.parent.parent, user)
  seen_topic_units_f = @manager.seen_units(resource, category.parent, user)
  if cos_sim_f.to_f > 0
    $output_file << "#{class_id} #{cos_sim_f} #{answers_in_week_f} #{answers_in_topic_f} #{votes_in_topic_f} #{votes_in_week_f} "\
                    "#{knowledge_gap_topic_f} #{knowledge_gap_week_f} #{knowledge_gap_total_f} "\
                    "#{seen_week_units_f} #{seen_topic_units_f}\n"
  end
end

# Add answers - if votes more than 0, than classid 1
answers = Shared::Answer.all
correct_count = 0
skip_count = 0
answers.each do |answer|
  skip_flag = true

  unless @manager.is_student(answer.author)
    # positive votes or BA
    if answer.votes_difference > 0 || answer.labels.count > 0
      class_id = 1
      skip_flag = false
      puts 'Class 1'
    # neutral votes and newer answer added
    elsif answer.votes_difference == 0 && answer.question.answers.where('created_at > ?', answer.created_at).count > 0
      class_id = 0
      skip_flag = false
      puts 'Newer answer added'
    # negative votes or negative vote from staff
    elsif answer.votes_difference < 0 || answer.votes.where(voter: Shared::Assignment.select(:user_id))
                                             .where(positive: :False).count > 0
      class_id = 0
      skip_flag = false
      puts 'Negative votes score or negative votes from teacher'
    end
  else
    puts 'Answerer is not student'
  end

  if skip_flag
    skip_count += 1
  else
    correct_count += 1
    build_features(answer, answer.question.category, answer.question, answer.author, class_id) unless skip_flag
  end
  update_bow(answer)

end

puts 'Correct count: ', correct_count
puts 'Skip count: ', skip_count

$output_file.close()