FactoryGirl.define do
  factory :watching, class: University::Watching do
    association :watcher
  end
end
