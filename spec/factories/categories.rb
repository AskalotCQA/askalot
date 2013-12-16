# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "Category ##{n}" }

    trait :with_tags do
      sequence(:tags) { |n| ["category-#{n}"] }
    end
  end
end
