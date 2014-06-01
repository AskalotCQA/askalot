module Yeast
  module EvaluationFeeder
    extend self

    attr_accessor :total_recall, :total_precision, :number_of_observations

    def total_precision
      @total_precision ||= 0
    end

    def total_recall
      @total_recall ||= 0
    end

    def number_of_observations
      @number_of_observations ||= 0
    end

    def publish(action, initiator, resource, options = {})
      if resource.is_a? Question
        return unless resource.stack_exchange_duplicate

        question = resource
        text     = [question.tags.pluck(:name)].flatten.join(' ')
        terms    = Question.probe.analyze(text: text, analyzer: :text) rescue nil

        return unless terms

        tags      = question.author.profiles.where(property: :interest).order(:value).limit(10).map { |p| { name: p.targetable.name, value: p.value } }
        query     = {
          query: {
            bool: {
              should: [],
              minimum_should_match: 2
            }
          }
        }

        terms.each do |term|
          query[:query][:bool][:should] << { term: { tags: term }}
        end

        query.deep_merge!({
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
          size: 20
        })

        retrieved_documents = results = Question.search(query)
        relevant_documents  = Question.where(stack_exchange_uuid: question.stack_exchange_questions_uuids)

        return unless retrieved_documents.size > 0
        return unless relevant_documents.size > 0

        puts "Found #{results.size} questions"

        precision = (retrieved_documents & relevant_documents).size / relevant_documents.size.to_f
        recall    = (retrieved_documents & relevant_documents).size / retrieved_documents.size.to_f

        self.total_precision        += precision
        self.total_recall           += recall
        self.number_of_observations += 1

        puts "Total Precision: #{total_precision / number_of_observations.to_f}"
        puts "Total Recall: #{total_recall / number_of_observations.to_f}"
      end
    end
  end
end



=begin
    def publish(action, initiator, resource, options = {})
      if resource.is_a? Question
        return if resource.stack_exchange_duplicate
        return unless Question.where(stack_exchange_duplicate: true).where("#{resource.stack_exchange_uuid} = ANY(stack_exchange_questions_uuids)").any?

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

              return result;

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
          size: 10
        )

        retrieved_documents = results
        relevant_documents  = Question.where(stack_exchange_duplicate: true).where("#{question.stack_exchange_uuid} = ANY(stack_exchange_questions_uuids)")

        return unless retrieved_documents.size > 0

        puts "Found #{results.size} questions"

        precision = (retrieved_documents & relevant_documents).size / relevant_documents.size.to_f
        recall    = (retrieved_documents & relevant_documents).size / retrieved_documents.size.to_f

        self.total_precision        += precision
        self.total_recall           += recall
        self.number_of_observations += 1

        puts "Total Precision: #{total_precision / number_of_observations.to_f}"
        puts "Total Recall: #{total_recall / number_of_observations.to_f}"
      end
    end
  end
=end
