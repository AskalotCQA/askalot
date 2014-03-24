namespace :fixtures do
  task all: :environment do
    Rake::Task['fixtures:users'].invoke
    Rake::Task['fixtures:categories'].invoke
    Rake::Task['fixtures:questions'].invoke
  end

  desc 'Fill database with sample user'
  task users: :environment do
    10.times do |n|
      User.create_without_confirmation!(login: "user_#{n}", email: Forgery(:email).address, password: 'password', password_confirmation: 'password') 
    end
  end

  desc 'Fills database with sample categories'
  task categories: :environment do
    10.times { |n| Category.create!(name: "Category ##{n}") }
  end

  desc 'Fills database with sample questions'
  task questions: :environment do
    99.times do |n|
      q = Question.create!(
        title: "Question ##{n}",
        text: Forgery(:lorem_ipsum).words(10),
        author_id: User.find(rand 1..5).id,
        category_id: Category.first.id,
        tag_list: Forgery(:lorem_ipsum).words(2).split(' ')
      )
      3.times do |n|
        Answer.create!(
          author_id: User.find(rand 6..10).id,
          question_id: q.id,
          text: Forgery(:lorem_ipsum).words(20),
        )
      end
    end
    namespace :category do
      desc "Fill category table with sample data"
      task populate: :environment do
        Category.create!(name: "Sample name",
                         id: 1)
        99.times do |n|
          name  = "sample name-#{n+1}"
          id = n+1
          Question.create!(name: name,
                           id: id)
        end
      end
    end
    namespace :users do
      desc "Fill table users with sample data"
      task populate: :environment do
        User.create_without_confirmation!(login: "SamplUser",
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
          User.create_without_confirmation!(login: login,
                                            email: email,
                                            encrypted_password: encrypted_password,
                                            nick: nick,
                                            password: password)
        end
      end
    end
  end
end
