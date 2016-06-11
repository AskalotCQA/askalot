FactoryGirl.define do
  factory :question, class: Shared::Question do
    sequence(:title) { |n| "Title #{n}" }

    text 'Lorem ipsum'
    anonymous false

    association :category
    association :author

    trait :anonymous do
      anonymous true
    end

    trait :deleted do
      deleted true
      deletor { self.author }
      deleted_at DateTime.now.in_time_zone
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
      sequence(:slido_question_uuid) { |n| n }
      sequence(:slido_event_uuid) { |n| n + 2 }
    end

    trait :discussion do
      question_type_id 3
    end
  end
end
