FactoryBot.define do
  factory :comment, class: Shared::Comment do
    association :author

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
