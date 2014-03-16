FactoryGirl.define do
  factory :evaluation do
    association :evaluator

    text 'Lorem ipsum'
    value 0
  end
end
