FactoryGirl.define do
  factory :assignment do
    association :user
    association :category
    association :role
  end
end
