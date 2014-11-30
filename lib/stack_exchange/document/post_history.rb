module StackExchange
  class Document
    class PostHistory < StackExchange::Document
      def process_element(history)
        question = Question.find_by(stack_exchange_uuid: history[:PostId])

        return unless question

        if ['1', '101'].include?(history[:Comment]) && history[:Text]
          ids = JSON.parse(history[:Text], symbolize_names: true)[:OriginalQuestionIds] rescue nil

          return unless ids

          question.update_columns(stack_exchange_duplicate: true, stack_exchange_questions_uuids: ids)

          question
        end
      end
    end
  end
end
