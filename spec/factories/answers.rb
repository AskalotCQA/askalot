FactoryGirl.define do
  factory :answer, class: University::Answer do
    association :author
    association :question

    text 'Lorem ipsum'

    trait :deleted do
      deleted true
      deletor { self.author }
      deleted_at DateTime.now.in_time_zone
    end
  end
end
