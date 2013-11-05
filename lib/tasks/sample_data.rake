namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    Question.create!(title: "Example Title",
                     text: "sample text",
                     user_id: 5,
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
                   user_id: user_id,
                   category_id: category_id,
                   answered: answered)
    end
  end
end