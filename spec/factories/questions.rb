# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :question do
    sequence(:title) { |n| "Title #{n}" }

    text      'Lorem ipsum'
    anonymous false

    association :category
    association :author

    trait :anonymous do
      anonymous true
    end

    trait :with_tags do
      sequence(:tag_list) { |n| "tag-#{n}" }
    end

    trait :with_answers do
      after :create do |question|
        3.times { create :answer, question: question }
      end
    end

    trait :from_slido do
      sequence(:slido_uuid)       { |n| n }
      sequence(:slido_event_uuid) { |n| n + 2 }
    end
  end
end
