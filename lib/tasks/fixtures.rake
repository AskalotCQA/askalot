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
      Question.create!(
        title: "Question ##{n}",
        text: Forgery(:lorem_ipsum).words(10),
        author_id: User.first.id,
        category_id: Category.first.id,
        tag_list: Forgery(:lorem_ipsum).words(2).split(' ')
      )
    end
  end
end
