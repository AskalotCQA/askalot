FactoryGirl.define do
  factory :news, class: Shared::New do
    title 'Test News'
    description 'News'
    show true
  end
end
