namespace :db do
      desc "Fill database with sample data"
      task populate: :environment do
        Question.create!(title: "Example Title",
                         text: "sample text",
                         author_id: 5,
                         category_id: 5)
        99.times do |n|
          title  = "SampleQuestion-#{n+1}"
          text = "sample-#{n+1}text"
          user_id = n+1
          category_id=n+1
          Question.create!(title: title,
                           text: text,
                           author_id: user_id,
                           category_id: category_id)
        end
      end
      desc "Fill table category with sample data"
      task populate: :environment do
        Category.create!(name: "SampleCategory")
        99.times do |n|
          name  = "sampleCategory-#{n+1}"
          Category.create!(name: name)
        end
      end

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
