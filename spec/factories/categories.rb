FactoryGirl.define do
  factory :category, class: Shared::Category do
    sequence(:name) { |n| "Category ##{n}" }
    sequence(:uuid) { |n| "uuid#{n}" }
    askable true
    visible true

    parent_id Rails.module.mooc? ? 2 : 3

    trait :with_tags do
      sequence(:tags) { |n| ["category-#{n}"] }
    end

    trait :with_slido do
      slido_username 'doge'
      slido_event_prefix 'such'
    end
  end
end
