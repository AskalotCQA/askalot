FactoryBot.define do
  factory :notification, class: Shared::Notification do
    association :recipient
    association :initiator
  end
end
