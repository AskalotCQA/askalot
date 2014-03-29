module StackOverflow
  class Processor
    class PostHistoryDocument < Nokogiri::XML::SAX::Document
      def start_document
        puts '[Posts] Start processing'
        @questions = []
        @count = 0
      end

      def end_document
        Answer.import @questions, :validate => false, :timestamps => false
        puts '[Posts] End processing'
      end

      def start_element(name, attributes = [])
        if name == 'row'
          history = Hash.new
          attributes.each do |attribute|
            history[attribute[0]] = attribute[1]
          end

          # Answer
          @count += 1
          puts '[PostHistory] Processing ' + @count.to_s + '. post history with ID: ' + history['Id']

          question = Question.find_by_imported_id history['PostId']

          return unless question

          if ['1', '101'].include?(history['Comment']) && history['Text']
            question.imported_duplicate = true
            question.original_imported_question_ids = JSON.parse(history['Text'])['OriginalQuestionIds']
            question.save!(validate: false, timestamps: false)
          end
        end
      end
    end
  end
end
