FactoryGirl.define do
  factory :news, class: Shared::News do
    title 'Test News'
    description 'News'
    show true
  end
end
