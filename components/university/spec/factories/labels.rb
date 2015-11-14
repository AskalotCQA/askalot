FactoryGirl.define do
  factory :label do
    sequence(:value) { |n| :"label-#{n}" }
  end
end
