FactoryGirl.define do
  factory :user, class: Shared::User, aliases: [:author, :followee, :follower, :favorer, :voter, :watcher, :viewer, :recipient, :initiator] do
    sequence(:login) { |n| "user_#{n}" }
    sequence(:email) { |n| "user_#{n}@example.com" }

    password              'password'
    password_confirmation 'password'

    first 'John'
    last  'Nash'
    about 'Lorem ipsum'

    show_email true
    show_name  true

    role :student

    factory :student, class: Shared::User do
      role :student
    end

    factory :teacher, class: Shared::User do
      role :teacher
    end

    factory :administrator, class: Shared::User do
      role :administrator
    end

    factory :mooc_user, class: Mooc::User if Rails.module.mooc?

    after :create do |user|
      user.confirm!

      Shared::ContextUser.create user: user, context_id: 1 if Rails.module.mooc?
    end

    trait :as_ais do
      sequence(:login)     { |n| "xuser#{n}" }
      sequence(:email)     { |n| "xuser#{n}@stuba.sk" }
      sequence(:ais_uid)   { |n| n }
      sequence(:ais_login) { |n| "xuser#{n}" }

      password              nil
      password_confirmation nil
    end

    trait :alumni do
      alumni true
    end

    trait :without_name do
      first  nil
      middle nil
      last   nil
    end

    trait :unconfirmed do
      after :create do |user|
        user.confirmation_token = nil
        user.confirmed_at       = nil

        user.save!
      end
    end
  end
end
