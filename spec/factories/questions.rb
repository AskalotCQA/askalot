# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Title #{n}" }

    text 'Lorem ipsum'

    association :category
    association :author

    trait :with_tags do
      sequence(:tag_list) { |n| "tag-#{n}" }
    end

    trait :with_answers do
      after :create do |question|
        3.times { create :answer, question: question }
      end
    end
  end
end
