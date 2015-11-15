FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "Category ##{n}" }

    trait :with_tags do
      sequence(:tags) { |n| ["category-#{n}"] }
    end

    trait :with_slido do
      slido_username 'doge'
      slido_event_prefix 'such'
    end
  end
end
