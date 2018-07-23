FactoryBot.define do
  factory :reputation_profile, class: Shared::User::Profile do
    targetable_id    1
    targetable_type  'Reputation'
    property         'reputation'
    value            0
    probability      0.0

    association :user
  end
end
