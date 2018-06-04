FactoryBot.define do
  factory :label, class: Shared::Label do
    sequence(:value) { |n| :"label-#{n}" }
  end
end
