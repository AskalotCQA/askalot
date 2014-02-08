module StackOverflow
  class Processor
    class CommentsDocument < Nokogiri::XML::SAX::Document
      def start_document
        puts '[Comments] Start processing'
        @comments = []
      end

      def end_document
        Comment.import @comments, :validate => false, :timestamps => false
        puts '[Comments] End processing'
      end

      def start_element name, attributes = []
        if name == 'row'
          comment = Hash.new
          attributes.each do |attribute|
            comment[attribute[0]] = attribute[1]
          end

          puts '[Comments] Processing comment with ID: ' + comment['Id']

          user = User.find_by_imported_id comment['UserId']
          question = Question.find_by_imported_id comment['PostId']
          answer = Answer.find_by_imported_id comment['PostId']

          comment = Comment.new(
              author_id: user.nil? ? 0 : user.id,
              commentable_id: question.nil? ? (answer.nil? ? 0 : answer.id) : question.id,
              commentable_type: question.nil? ? 'Answer' : 'Question',
              text: ActionView::Base.full_sanitizer.sanitize(comment['Text'].gsub('/</p> <p>/','\n')),
              created_at: comment['CreationDate'],
              updated_at: comment['CreationDate'],
              imported_id: comment['Id']
          )

          @comments << comment

          if @comments.count > 1000
            Comment.import @comments, :validate => false, :timestamps => false
            @comments = []
          end
        end
      end
    end
  end
end