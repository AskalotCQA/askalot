module StackExchange
  class Document
    class Comments < StackExchange::Document
      def process_element(comment)
        user        = Mapper.users[comment[:UserId]]
        question    = Mapper.questions[comment[:PostId]]
        answer      = Mapper.answers[comment[:PostId]]
        commentable = question.nil? ? answer : question
        type        = question.nil? ? 'University::Answer' : 'University::Question'

        return if commentable.nil? || user.nil?

        return if University::Comment.exists?(stack_exchange_uuid: comment[:Id])

        comment = University::Comment.new(
          author_id:           user[:id],
          commentable_id:      commentable[:id],
          commentable_type:    type,
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
