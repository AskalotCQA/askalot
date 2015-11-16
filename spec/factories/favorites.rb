FactoryGirl.define do
  factory :favorite, class: University::Favorite do
    association :question
    association :favorer
  end
end
