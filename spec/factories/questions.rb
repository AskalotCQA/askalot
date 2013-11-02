# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Title #{n}" }

    text 'Text'

    association :category
    association :user
  end
end
