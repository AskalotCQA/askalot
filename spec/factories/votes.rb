FactoryGirl.define do
  factory :vote, class: University::Vote do
    association :voter
  end
end
