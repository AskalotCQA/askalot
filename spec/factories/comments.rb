FactoryGirl.define do
  factory :comment do
    association :author

    text 'Lorem ipsum'
  end
end
