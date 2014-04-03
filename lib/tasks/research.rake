namespace :research do
  namespace :questions do
    desc 'Searches similar questions'
    task search: :environment do
      question = Question.find(ENV['QUESTION'])
      text     = [question.title, question.text, question.tags].join(' ')
      terms    = Question.probe.analyze(text: text, analyzer: :text)

      puts ({
        query: {
          more_like_this: {
            like_text: text,
            fields: [:title, :text, :tags],
            min_term_freq: 1
          }
        },
        sort: {
          _script: {
            script: "
              result = doc.score;
              size   = _index.numDocs();

              foreach(term : terms) {
                frequency       = _index['title'][term].tf() + _index['text'][term].tf() + _index['tags'][term].tf();
                total_frequency = _index['title'][term].ttf() + _index['text'][term].ttf() + _index['tags'][term].ttf();

                if (frequency > 0 && total_frequency > 0) {
                  result += frequency * log((size / total_frequency) + 1);
                }
              }

              return result;
            ",
            type: :number,
            order: :desc,
            params: {
              terms: terms,
            }
          }
        }
      }).to_json
    end
  end
end
