FactoryBot.define do
  factory :tag, class: Shared::Tag do
    sequence(:name) { |n| "tag-#{n}" }
    max_time { rand(18000..100000.0) }
    max_votes_difference 5
    min_votes_difference -5
  end
end
