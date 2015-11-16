FactoryGirl.define do
  factory :evaluation, class: University::Evaluation do
    association :author

    text 'Lorem ipsum'
    value 0
  end
end
