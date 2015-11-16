FactoryGirl.define do
  factory :assignment, class: University::Assignment do
    association :user
    association :category
    association :role
  end
end
