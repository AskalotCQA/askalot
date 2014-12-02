module StackExchange
  class Document
    class Tags < StackExchange::Document
      def process_element(tag)
        return if Tag.exists?(stack_exchange_uuid: tag[:Id])

        tag = Tag.new(
          name:                tag[:TagName],
          stack_exchange_uuid: tag[:Id],
          created_at:          Time.now,
          updated_at:          Time.now
        )

        tag
      end
    end
  end
end
