FactoryBot.define do
  factory :favorite, class: Shared::Favorite do
    association :question
    association :favorer
  end
end
