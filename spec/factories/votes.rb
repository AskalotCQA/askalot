FactoryBot.define do
  factory :vote, class: Shared::Vote do
    association :voter
  end
end
