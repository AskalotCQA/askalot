# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    sequence(:login) { |n| "User ##{n}" }
    sequence(:email) { |n| "user#{n}@gmail.com" }

    password              'password'
    password_confirmation 'password'

    after :create do |user|
      user.confirm!
    end
  end
end
