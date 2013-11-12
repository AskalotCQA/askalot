# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Title #{n}" }

    text 'Lorem ipsum'

    association :category
    association :author
  end
end
