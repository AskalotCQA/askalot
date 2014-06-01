def dot_product(a, b)
  products = a.zip(b).map{|x, y| x * y}
  products.inject(0) {|s,p| s + p}
end

def magnitude(point)
  squares = point.map{|x| x ** 2}
  Math.sqrt(squares.inject(0) {|s, c| s + c})
end

# Returns the cosine of the angle between the vectors 
#associated with 2 points
#
# Params:
#  - a, b: list of coordinates (float or integer)
#
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

namespace :test do
  desc 'Task description'
  task lda: :environment do
    corpus    = Lda::Corpus.new
    parents   = []
    questions = Question.limit(1000)

    questions.each do |question|
      next unless question.stack_exchange_duplicate

      parents << Question.where(stack_exchange_uuid: question.stack_exchange_questions_uuids)
    end

    questions = (questions + parents.flatten).uniq

    questions.each do |question|
      document = Lda::TextDocument.new(corpus, [question.title, question.text, question.tags.pluck(:name)].join(' '))

      corpus.add_document(document)
    end

    lda = Lda::Lda.new(corpus)

    lda.em('random')

    matrix = lda.compute_topic_document_probability

    questions.each do |question|
      next unless question.stack_exchange_duplicate

      duplicate = question
      originals = Question.where(stack_exchange_uuid: question.stack_exchange_questions_uuids)

      originals.each do |original|
        puts "#{cosine_similarity(matrix[questions.index(original)], matrix[questions.index(question)])} (#{original.stack_exchange_uuid}/#{duplicate.stack_exchange_uuid})"

        similarities = []

        questions.each_with_index do |other, index|
          next if other == duplicate || other == original

          similarity = cosine_similarity(matrix[questions.index(other)], matrix[questions.index(original)])

          similarities << similarity if !similarity.nan? || similarity.abs != Float::INFINITY
        end

        puts "\t#{similarities.sum / similarities.size}"
        puts "-----------------------------------------"
        similarities.sort.last(5).each do |similarity|
          puts "\t#{similarity}"
        end
      end
    end
  end
end
