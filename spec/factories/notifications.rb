FactoryGirl.define do
  factory :notification, class: University::Notification do
    association :recipient
    association :initiator
  end
end
