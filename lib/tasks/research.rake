namespace :research do
  namespace :questions do
    desc 'Searches similar questions'
    task search: :environment do
      question = Question.find(ENV['QUESTION'])
      text     = [question.title, question.text, question.tags].join(' ')
      terms    = Question.probe.analyze(text: text, analyzer: :text)

      puts ({
        query: {
          query_string: {
            query: text,
            default_operator: :or
          }
        },
        sort: {
          _script: {
            script: "
              score = doc.score;
              size  = _index.numDocs();

              foreach(term : terms) {
                frequency       = _index['title'][term].tf() + _index['text'][term].tf() + _index['tags'][term].tf();
                total_frequency = _index['title'][term].ttf() + _index['text'][term].ttf() + _index['tags'][term].ttf();

                if (frequency > 0 && total_frequency > 0) {
                  score += frequency * log(size / total_frequency);
                }
              }

              return score;
            ",
            type: :number,
            params: {
              terms: terms,
            }
          }
        }
      }).to_json
    end
  end
end
