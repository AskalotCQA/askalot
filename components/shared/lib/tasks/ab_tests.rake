namespace :ab_tests do
  desc 'Split users into 3 groups'
  task split_users: :environment do
    users_ids = Shared::User.order('answers_count DESC')
                    .pluck(:id)

    first_group = []
    second_group = []
    third_group = []
    users_ids.each_with_index do |val, index|
      if index % 3 == 0
        first_group << val
      elsif index % 3 == 1
        second_group << val
      elsif index % 3 == 2
        third_group << val
      end
    end

    Shared::AbGrouping.destroy_all
    insert_into_table(first_group, Shared::AbGroup.find_by(value: 'Question routing full')) # Viddick
    insert_into_table(second_group, Shared::AbGroup.find_by(value: 'Question routing baseline')) # kdgoodenough
    insert_into_table(third_group, Shared::AbGroup.find_by(value: 'Control group for question routing'))

    puts '#1 size:', first_group.size
    puts '#2 size:', second_group.size
    puts '#3 size:', third_group.size

    puts '#1 answers count:', sum_feature_stats(first_group, :answers_count)
    puts '#2 answers count:', sum_feature_stats(second_group, :answers_count)
    puts '#3 answers count:', sum_feature_stats(third_group, :answers_count)

    puts '#1 questions count:', sum_feature_stats(first_group, :questions_count)
    puts '#2 questions count:', sum_feature_stats(second_group, :questions_count)
    puts '#3 questions count:', sum_feature_stats(third_group, :questions_count)

    puts '#1 comments count:', sum_feature_stats(first_group, :comments_count)
    puts '#2 comments count:', sum_feature_stats(second_group, :comments_count)
    puts '#3 comments count:', sum_feature_stats(third_group, :comments_count)

    puts '#1 views count:', sum_feature_stats(first_group, :views_count)
    puts '#2 views count:', sum_feature_stats(second_group, :views_count)
    puts '#3 views count:', sum_feature_stats(third_group, :views_count)
  end
end


def insert_into_table(user_ids, group)
  user_ids.each do |id|
    Shared::AbGrouping.create(user_id: id, ab_group: group).save
  end
end

def sum_feature_stats(group_ids, feature)
  suma = 0
  group_ids.each do |i|
    suma += Shared::User.find(i)[feature] if Shared::User.exists?(i)
  end
  return suma
end