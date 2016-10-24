
def mean(array)
  array.inject(0) { |sum, x| sum += x } / array.size.to_f
end

def standard_deviation(array)
  m = mean(array)
  variance = array.inject(0) { |variance, x| variance += (x - m) ** 2 }
  return Math.sqrt(variance/(array.size-1))
end

def get_group_number(random_gen, id)
  random = random_gen.rand(3)
  if random < 1
    return 0
  elsif random < 2
    return 1
  end
  return 2
end

def sum_feature_stats(group_ids, feature)
  suma = 0
  group_ids.each do |i|
    suma += Shared::User.find(i)[feature] if Shared::User.exists?(i)
  end
  return suma
end

def sample_to_groups(random_gen, last_id)
  zero_group = []
  first_group = []
  second_group = []
  (1..last_id) .each do |id|
    group = get_group_number(random_gen, id)
    if group == 0
      zero_group.append(id)
    elsif group == 1
      first_group.append(id)
    else
      second_group.append(id)
    end
  end
  return zero_group, first_group, second_group
end


last_id = Shared::User.last.id
best_seed = 1000
best_sdt = 9999
(1..400).each do |s|
  random_gen = Random.new(seed=s)

  zero_group, first_group, second_group = sample_to_groups(random_gen, last_id)

  std = standard_deviation([sum_feature_stats(zero_group, :answers_count), sum_feature_stats(first_group, :answers_count),
                            sum_feature_stats(second_group, :answers_count)])


  if std < best_sdt
    best_sdt = std
    best_seed = s
  end

end


print 'Best seed:', best_seed
random_gen = Random.new(seed=best_seed)
zero_group, first_group, second_group = sample_to_groups(random_gen, last_id)

puts '#1 answers count:', sum_feature_stats(zero_group, :answers_count)
puts '#2 answers count:', sum_feature_stats(first_group, :answers_count)
puts '#3 answers count:', sum_feature_stats(second_group, :answers_count)

puts '#1 questions count:', sum_feature_stats(zero_group, :questions_count)
puts '#2 questions count:', sum_feature_stats(first_group, :questions_count)
puts '#3 questions count:', sum_feature_stats(second_group, :questions_count)

puts '#1 views count:', sum_feature_stats(zero_group, :views_count)
puts '#2 views count:', sum_feature_stats(first_group, :views_count)
puts '#3 views count:', sum_feature_stats(second_group, :views_count)