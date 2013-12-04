# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user, aliases: [:author] do
    sequence(:login) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }

    password              'password'
    password_confirmation 'password'

    sequence(:nick) { |n| "jnash#{n}" }

    first 'John'
    last  'Nash'
    about 'Lorem ipsum'

    role User::ROLES.first

    trait :as_teacher do
      role :teacher
    end

    trait :as_admin do
      role :admin
    end

    after :create do |user|
      user.confirm!
    end

    trait :as_ais do
      sequence(:login)     { |n| "xuser#{n}" }
      sequence(:email)     { |n| "xuser#{n}@stuba.sk" }
      sequence(:ais_uid)  { |n| n }
      sequence(:ais_login) { |n| "xuser#{n}" }

      password              nil
      password_confirmation nil
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
