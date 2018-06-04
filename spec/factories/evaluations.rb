FactoryBot.define do
  factory :evaluation, class: Shared::Evaluation do
    association :author

    text 'Lorem ipsum'
    value 0
  end
end
