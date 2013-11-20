FactoryGirl.define do
  factory :favorite do
    association :question
    association :user
  end
end
