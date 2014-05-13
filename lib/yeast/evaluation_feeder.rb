module Yeast
  module EvaluationFeeder
    extend self

    attr_accessor :found, :total

    def found
      @found ||= 0
    end

    def total
      @total ||= 0
    end

    def publish(action, initiator, resource, options = {})
      if resource.is_a? Question
        return unless resource.stack_exchange_duplicate

        question  = resource
        text      = [question.title, question.text, question.tags.pluck(:name)].flatten.join(' ')
        terms     = Question.probe.analyze(text: text, analyzer: :text)
        tags      = question.author.profiles.where(property: :interest).order(:value).limit(10).map { |p| { name: p.targetable.name, value: p.value } }
        results   = Question.search(
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

              foreach(tag : tags) {
                name = tag['name'];

                if (_index['tags'][name].tf() > 0) {
                  result += tag['value'];
                }
              }

              return result;
              ",
                type: :number,
                order: :desc,
                params: {
                  terms: terms,
                  tags: tags
                }
            }
          },
          from: 0,
          size: 30
        )

        puts "Found #{results.size} questions"

        found = 0
        total = question.stack_exchange_questions_uuids.size

        results.each do |result|
          found += 1 if question.stack_exchange_questions_uuids.include? result.stack_exchange_uuid
        end

        self.total += total
        self.found += found

        puts "Duplicate detection success: #{self.found / self.total.to_f} (#{self.found}/#{self.total})"
      end
    end
  end
end
