namespace :elasticsearch do
  client = Elasticsearch::Client.new

  desc 'Imports Questions into Elasticsearch'
  task import: :environment do
    client.indices.delete index: :questions if client.indices.exists index: :questions

    client.indices.create index: :questions, type: :question, body: {
      settings: {
        index: {
          number_of_shards: 1,
          number_of_replicas: 0
        },

        analysis: {
          analyzer: {
            text: {
              type: :custom,
              tokenizer: :keyword,
              filter: [:asciifolding, :lowercase, :trim]
            },

            tags: {
              type: :custom,
              tokenizer: :tag,
              filter: [:asciifolding]
            }
          },

          tokenizer: {
            tag: {
              type: :pattern,
              pattern: '-*(\w+)-*',
              group: 0
            }
          }
        },

        mappings: {
          question: {
            properties: {
              id: {
                type: :integer
              },
              title: {
                type: :string,
                analyzer: :text
              },
              text: {
                type: :string,
                analyzer: :text
              },
              tags: {
                type: :string,
                analyzer: :tags
              }
            }
          }
        }
      }
    }

    Question.find_each do |question|
      client.index({
        index: :questions,
        type: :question,
        body: {
          id:    question.id,
          title: question.title,
          text:  question.text,
          tags:  question.tags.pluck(:name)
        }
      })
    end
  end

  desc 'Analyzes similar questions'
  task similar_questions: :environment do
    Question.find_each do |question|
      result = client.search index: :questions, body: {
        query: {
          more_like_this: {
            like_text: question.text,
            min_term_freq: 1,
            max_query_terms: 5,
            min_doc_freq: 1,
            stop_words: [
              "a", "aby", "aj", "ak", "ako", "ale", "alebo", "and", "ani", "áno", "asi", "až", "bez", "bude",
              "budem", "budeš", "budeme", "budete", "budú", "by", "bol", "bola", "boli", "bolo", "byť", "cez",
              "čo", "či", "ďalší", "ďalšia", "ďalšie", "dnes", "do", "ho", "ešte", "i", "ja", "je", "jeho", "jej",
              "ich", "iba", "iné", "iný", "som", "si", "sme", "sú", "k", "kam", "každý", "každá", "každé", "každí",
              "kde", "keď", "kto", "ktorá", "ktoré", "ktorou", "ktorý", "ktorí", "ku", "lebo", "len", "ma", "mať", "má",
              "máte", "medzi", "mi", "mna", "mne", "mnou", "musieť", "môcť", "môj", "môže", "my", "na", "nad", "nám", "náš",
              "naši", "nie", "nech", "než", "nič", "niektorý", "nové", "nový", "nová", "nové", "noví", "o", "od", "odo", true,
              "ona", "ono", "oni", "ony", "po", "pod", "podľa", "pokiaľ", "potom", "práve", "pre", "prečo", "preto", "pretože",
              "prvý", "prvá", "prvé", "prví", "pred", "predo", "pri", "pýta", "s", "sa", "so", "si", "svoje", "svoj", "svojich",
              "svojím", "svojími", "ta", "tak", "takže", "táto", "teda", "ten", "tento", "tieto", "tým", "týmto", "tiež", "to", "toto",
              "toho", "tohoto", "tom", "tomto", "tomuto", "toto", "tu", "tú", "túto", "tvoj", "ty", "tvojími", "už", "v", "vám", "váš",
              "vaše", "vo", "viac", "však", "všetok", "vy", "z", "za", "zo", "že"
            ]
          }
        }
      }.deep_symbolize_keys

      puts "Title: #{question.title}"
      puts "Text:  #{question.text.strip.gsub(/\s+\n/, ' ')}"
      puts "Tags:  #{question.tags.pluck(:name)}"

      results = result['hits']['hits'].select { |hit| hit['_source']['id'] != question.id }.first(3)

      puts "\nSimilar Questions (#{results.count}):\n\n"

      results.each do |hit|
        result = OpenStruct.new(hit['_source'])

        puts "\tTitle: #{result.title}"
        puts "\tText:  #{result.text.strip.gsub(/\s+\n/, ' ')}"
        puts "\tTags:  #{result.tags}"
        puts "\tScore: #{hit['_score']}"

        puts "\n"
      end

      puts "---------------------------------------------------\n\n"
    end
  end
end
