FactoryGirl.define do
  factory :answer do
    association :author
    association :question

    text 'Lorem ipsum'
  end
end
