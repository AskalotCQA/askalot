FactoryGirl.define do
  factory :watching, class: Shared::Watching do
    association :watcher
  end
end
