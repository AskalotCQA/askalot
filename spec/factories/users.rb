# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:login) { |n| "user_#{n}" }
    sequence(:email) { |n| "user#{n}@gmail.com" }

    password              'password'
    password_confirmation 'password'

    after :create do |user|
      user.confirm!
    end

    trait :unconfirmed do
      confirmed_at nil
    end
  end
end
