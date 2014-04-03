module StackExchange
  class Document
    class PostHistory < StackExchange::Document
      def process_element(history)
        question = Question.find_by(stack_exchange_uuid: history[:PostId])

        return unless question

        if ['1', '101'].include?(history[:Comment]) && history[:Text]
          question.stack_exchange_duplicate       = true
          question.stack_exchange_questions_uuids = JSON.parse(history[:Text], symbolize_names: true)[:OriginalQuestionIds]

          question.save!(validate: false, timestamps: false)
        end
      end
    end
  end
end
