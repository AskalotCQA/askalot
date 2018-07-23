FactoryBot.define do
  factory :answer, class: Shared::Answer do
    association :author
    association :question

    text 'Lorem ipsum'

    trait :anonymous do
      anonymous true
    end

    trait :deleted do
      deleted true
      deletor { self.author }
      deleted_at DateTime.now.in_time_zone
    end
  end
end
