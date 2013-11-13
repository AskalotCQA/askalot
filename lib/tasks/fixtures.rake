namespace :fixtures do
  namespace :db do
    namespace :questions do
      desc "Fill database with sample data"
      task populate: :environment do
        Question.create!(title: "Example Title",
                         text: "sample text",
                         author_id: 5,
                         category_id: 5)
        99.times do |n|
          title  = "sample title-#{n + 1}"
          text = "sample-#{n + 1}text"
          author_id = n + 1
          category_id = n + 1
          Question.create!(title: title,
                       text: text,
                       author_id: author_id,
                       category_id: category_id)
        end
      end
    end
  end
end
