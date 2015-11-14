FactoryGirl.define do
  factory :favorite do
    association :question
    association :favorer
  end
end
