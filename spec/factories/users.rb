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

    trait :with_ais do
      ais_uid '1234'
      ais_login 'user'
    end

    trait :unconfirmed do
      after :create do |user|
        user.confirmation_token = nil
        user.confirmed_at = nil

        user.save!
      end
    end
  end
end
