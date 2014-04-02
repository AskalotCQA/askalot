namespace :research do
  namespace :questions do
    desc 'Searches similar questions'
    task search: :environment do
      question = Question.find(ENV['QUESTION'])

      results = Question.probe.search(
        query: {
          query_string: {
            query: [question.title, question.text, question.tags].join(' ')
          }
        }
      )

      puts JSON.pretty_print(results.map(&:to_h))
    end
  end
end
