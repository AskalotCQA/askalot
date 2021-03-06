namespace :fixtures do
  task all: :environment do
    Rake::Task['fixtures:users'].invoke
    Rake::Task['fixtures:categories'].invoke
    Rake::Task['fixtures:questions'].invoke
  end

  desc 'Fill database with sample user'
  task users: :environment do
    10.times do |n|
      Shared::User.create_without_confirmation!(login: "user_#{n}", email: Forgery(:email).address, password: 'password', password_confirmation: 'password')
    end
  end

  desc 'Fills database with sample categories'
  task categories: :environment do
    10.times { |n| Shared::Category.create!(name: "Category ##{n}") }
  end

  desc 'Fills database with sample questions'
  task questions: :environment do
    99.times do |n|
      q = Shared::Question.create!(
        title: "Question ##{n}",
        text: Forgery(:lorem_ipsum).words(10),
        author_id: Shared::User.find(rand 1..5).id,
        category_id: Shared::Category.first.id,
        tag_list: Forgery(:lorem_ipsum).words(2).split(' ')
      )
      3.times do |n|
        Shared::Answer.create!(
          author_id: User.find(rand 6..10).id,
          question_id: q.id,
          text: Forgery(:lorem_ipsum).words(20),
        )
      end
    end
    namespace :category do
      desc "Fill category table with sample data"
      task populate: :environment do
        Shared::Category.create!(name: "Sample name",
                         id: 1)
        99.times do |n|
          name  = "sample name-#{n+1}"
          id = n+1
          Shared::Question.create!(name: name,
                           id: id)
        end
      end
    end
    namespace :users do
      desc "Fill table users with sample data"
      task populate: :environment do
        Shared::User.create_without_confirmation!(login: "SamplUser",
                                          email: "example@railstutorial.org",
                                          encrypted_password: "password123",
                                          nick: "sample nick",
                                          password: "password123")
        99.times do |n|
          login  = "UserLogin#{n+1}"
          email = "example-#{n+1}@naruby.org"
          encrypted_password= "password123"
          nick= "samplenick-#{n+1}"
          password= "password123"
          Shared::User.create_without_confirmation!(login: login,
                                            email: email,
                                            encrypted_password: encrypted_password,
                                            nick: nick,
                                            password: password)
        end
      end
    end
  end

  desc 'Updates cache for tags\' statistics'
  task tag_statistics: :environment do
    Shared::Tag.all.each do |t|
      puts "Updating tag ##{t.id}."
      Shared::Reputation::Adjuster.update_tag_statistics(t)
    end
  end

  desc 'Creates missing reputation profiles'
  task reputation_profiles: :environment do
    Shared::User.all.each do |u|
      u.profiles.of('reputation').first_or_create do |p|
        p.targetable_id   = 1
        p.targetable_type = 'Reputation'
        p.property        = 'Reputation'
        p.value           = 0
        p.probability     = 0.0
        p.save
      end
    end
  end
end
