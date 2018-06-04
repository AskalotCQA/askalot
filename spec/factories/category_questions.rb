FactoryBot.define do
  factory :category_question, class: Shared::CategoryQuestion do
    association :category
    association :question
  end
end
