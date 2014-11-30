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

namespace :research do
  namespace :questions do
    desc 'Generate LDA of questions'
    task lda: :environment do
      Question::Profile.delete_all(source: :LDA)

      corpus    = Lda::Corpus.new
      questions = Question.all

      questions.each do |question|
        document = Lda::TextDocument.new(corpus, [question.title, question.text, question.tags.pluck(:name)].join(' '))

        corpus.add_document(document)
      end

      lda = Lda::Lda.new(corpus)

      lda.em('random')

      matrix = lda.compute_topic_document_probability

      questions.each_with_index do |question, index|
        topics = matrix[index]

        topics.each_with_index do |value, number|
          Question::Profile.find_or_create_by!(question: question, property: "Topic ##{number}", value: value, source: :LDA)
        end
      end
    end
  end
end
