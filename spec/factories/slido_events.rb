FactoryBot.define do
  factory :slido_event, class: Shared::SlidoEvent do
    sequence(:name)       { |n| "Slido Event ##{n}" }
    sequence(:uuid)       { |n| n }
    sequence(:identifier) { |n| "abc#{n}" }
    sequence(:url)        { |n| "https://sli.do/user/#{identifier}" }

    started_at { Time.now }
    ended_at   { Time.now + 2.days }
  end
end
