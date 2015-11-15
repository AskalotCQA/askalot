FactoryGirl.define do
  factory :evaluation do
    association :author

    text 'Lorem ipsum'
    value 0
  end
end
