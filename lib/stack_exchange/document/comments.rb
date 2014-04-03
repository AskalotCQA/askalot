module StackExchange
  class Document
    class Comments < StackExchange::Document
      def process_element(comment)
        user     = User.find_by(stack_exchange_uuid: comment[:UserId])
        question = Question.find_by(stack_exchange_uuid: comment[:PostId])
        answer   = Answer.find_by(stack_exchange_uuid: comment[:PostId])

        comment = Comment.new(
          author_id:           user.nil? ? 0 : user.id,
          commentable_id:      question.nil? ? (answer.nil? ? 0 : answer.id) : question.id,
          commentable_type:    question.nil? ? :Answer : :Question,
          text:                ActionView::Base.full_sanitizer.sanitize(comment[:Text]).to_s,
          created_at:          comment[:CreationDate],
          updated_at:          comment[:CreationDate],
          stack_exchange_uuid: comment[:Id]
        )

        return comment
      end
    end
  end
end
