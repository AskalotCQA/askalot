FactoryGirl.define do
  factory :label, class: University::Label do
    sequence(:value) { |n| :"label-#{n}" }
  end
end
