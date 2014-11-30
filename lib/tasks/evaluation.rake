def dot_product(a, b)
  products = a.zip(b).map{|x, y| x * y}
  products.inject(0) {|s,p| s + p}
end

def magnitude(point)
  squares = point.map{|x| x ** 2}
  Math.sqrt(squares.inject(0) {|s, c| s + c})
end

def cosine_similarity(a, b)
  result = dot_product(a, b) / (magnitude(a) * magnitude(b))

  result
end

Lda::Lda.class_eval do
  def compute_topic_document_probability
    outp = Array.new

    @corpus.documents.each_with_index do |doc, idx|
      tops = [0.0] * self.num_topics
      self.phi[idx].each_with_index do |word_dist, word_idx|
        word_dist.each_with_index do |top_prob, top_idx|
          tops[top_idx] += top_prob
        end
      end
      outp << tops
    end

    outp
  end
end

namespace :evaluation do
  desc 'Task description'
  task lda: :environment do
    corpus    = Lda::Corpus.new
    originals = []
    questions = Question.all

    questions.each do |question|
      next unless question.stack_exchange_duplicate

      originals << Question.where(stack_exchange_uuid: question.stack_exchange_questions_uuids)
    end

    questions = (questions + originals.flatten).uniq

    questions.each do |question|
      document = Lda::TextDocument.new(corpus, [question.title, question.text, question.tags.pluck(:name)].join(' '))

      corpus.add_document(document)
    end

    lda = Lda::Lda.new(corpus)

    lda.em('random')

    matrix                  = lda.compute_topic_document_probability
    total_precision         = 0
    total_recall            = 0
    number_of_observations  = 0

    questions.each do |question|
      next unless question.stack_exchange_duplicate

      duplicate    = question
      similarities = Hash.new

      questions.each_with_index do |other, index|
        next if other == duplicate

        index_of_duplicate = questions.index(duplicate)
        index_of_question  = questions.index(other)

        similarities[index] = cosine_similarity(matrix[index_of_duplicate], matrix[index_of_question])
      end

      relevant_documents  = Question.where(stack_exchange_uuid: duplicate.stack_exchange_questions_uuids)
      retrieved_documents = similarities.sort_by { |_, value| value }.last(10).map { |key, _| questions[key] }

      next unless retrieved_documents.size > 0
      next unless relevant_documents.size > 0

      precision = (retrieved_documents & relevant_documents).size / relevant_documents.size.to_f
      recall    = (retrieved_documents & relevant_documents).size / retrieved_documents.size.to_f

      total_precision        += precision
      total_recall           += recall
      number_of_observations += 1

      puts "Total Precision:  #{total_precision / number_of_observations.to_f} (#{total_precision} / #{number_of_observations})"
      puts "Total Recall:     #{total_recall / number_of_observations.to_f} (#{total_recall} / #{number_of_observations})"
    end
  end
end
