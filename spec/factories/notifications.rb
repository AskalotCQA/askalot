FactoryGirl.define do
  factory :notification do
    association :recipient
    association :initiator
  end
end
