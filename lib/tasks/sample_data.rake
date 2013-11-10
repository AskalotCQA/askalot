namespace :db do
      desc "Fill database with sample data"
      task populate: :environment do
        Question.create!(title: "Example Title",
                         text: "sample text",
                         author_id: 5,
                         category_id: 5,
                         answered: 1)
        99.times do |n|
          title  = "sample title-#{n+1}"
          text = "sample-#{n+1}text"
          user_id = n+1
          category_id=n+1
          answered=1
          Question.create!(title: title,
                           text: text,
                           author_id: user_id,
                           category_id: category_id,
                           answered: answered)
        end
      end
      desc "Fill table category with sample data"
      task populate: :environment do
        Category.create!(name: "Sample name")
        99.times do |n|
          name  = "sample name-#{n+1}"
          Category.create!(name: name)
        end
      end
      desc "Fill table tagsss with sample data"
      task populate: :environment do
        QuestionTagging.create!(question_id: 1)
        99.times do |n|
          question_id= n+1
          QuestionTagging.create!(question_id: question_id)
        end
      end
      desc "Fill table tags with sample data"
      task populate: :environment do
        QuestionTag.create!(name: "Sample login")
        99.times do |n|
          name  = "Tag-#{n+1}"
          QuestionTag.create!(name: name)
        end
      end
      desc "Fill table users with sample data"
      task populate: :environment do
        User.create_without_confirmation!(login: "sampl1s0elogin",
                     email: "example@railstutorial.org",
                     encrypted_password: "password123",
                     nick: "sample nick",
                     password: "password123")
        99.times do |n|
          login  = "samplename#{n+1}"
          email = "example-#{n+1}@railstutorial.org"
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
