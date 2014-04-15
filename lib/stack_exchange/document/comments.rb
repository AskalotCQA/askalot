module StackExchange
  class Document
    class Comments < StackExchange::Document
      def process_element(comment)
        user        = User.find_by(stack_exchange_uuid: comment[:UserId])
        question    = Question.find_by(stack_exchange_uuid: comment[:PostId])
        answer      = Answer.find_by(stack_exchange_uuid: comment[:PostId])
        commentable = question.nil? ? answer : question

        return if commentable.nil? || user.nil?

        return if Comment.exists?(stack_exchange_uuid: comment[:Id])

        comment = Comment.new(
          author:              user,
          commentable:         commentable,
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
