FactoryBot.define do
  factory :assignment, class: Shared::Assignment do
    association :user
    association :category
    association :role
  end
end
