module Yeast
  module EvaluationFeeder
    extend self

    attr_accessor :strategy, :total_recall, :total_precision, :number_of_observations

    def total_precision
      @total_precision ||= 0
    end

    def total_recall
      @total_recall ||= 0
    end

    def number_of_observations
      @number_of_observations ||= 0
    end

    def strategy
      @strategy ||= Hash.new
    end

    def publish(action, initiator, resource, options = {})
      if resource.is_a? Question
        return unless resource.stack_exchange_duplicate

        question = resource
        text     = [question.tags.pluck(:name)].flatten.join(' ')
        terms    = Question.probe.analyze(text: text, analyzer: :text) rescue nil

        return unless terms

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

        query.deep_merge!(strategy.call(question, terms))
        query.merge!(from: 0, size: 10)

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


        precision = total_precision / number_of_observations.to_f
        recall = total_recall / number_of_observations.to_f

        puts "Total Precision: #{precision}"
        puts "Total Recall: #{recall}"
        puts "F1 Measure: #{2 * (precision * recall)/(precision + recall)}"
      end
    end
  end
end
