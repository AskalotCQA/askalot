module StackExchange
  class Document
    class Posts < StackExchange::Document
      def process_element(post, options = {})
        if post[:PostTypeId] == '1'
          user = User.find_by(stack_exchange_uuid: post[:OwnerUserId])

          return unless user

          return if Question.exists?(stack_exchange_uuid: post[:Id])

          question = Question.new(
            author:              user,
            category:            Category.first,
            title:               post[:Title], # TODO (smolnar) make title only 145 characters long, restrictions on DB
            text:                ActionView::Base.full_sanitizer.sanitize(post[:Body]).to_s,
            created_at:          post[:CreationDate],
            updated_at:          post[:CreationDate],
            touched_at:          post[:CreationDate],
            stack_exchange_uuid: post[:Id]
          )

          tags = post[:Tags].gsub(/^</,'').gsub(/>$/,'').split(/></).map do |t|
            t.downcase.gsub(/[^[:alnum:]]+/, '-').gsub(/\A-|-\z/, '')
          end

          return question, -> do
            question = Question.find_by(stack_exchange_uuid: post[:Id])

            taggings = tags.uniq.map do |name|
              tag = Tag.find_or_create_by! name: name

              Tagging.new tag: tag, question: question, author: question.author
            end

            Tagging.import taggings, validate: false
          end
        end

        if post[:PostTypeId] == '2'
          user     = User.find_by(stack_exchange_uuid: post[:OwnerUserId])
          question = Question.find_by(stack_exchange_uuid: post[:ParentId])

          return if user.nil? || question.nil?

          return if Answer.exists?(stack_exchange_uuid: post[:Id])

          answer = Answer.new(
            author:              user,
            question:            question,
            text:                ActionView::Base.full_sanitizer.sanitize(post[:Body]).to_s,
            created_at:          post[:CreationDate],
            updated_at:          post[:CreationDate],
            stack_exchange_uuid: post[:Id]
          )

          return answer
        end
      end
    end
  end
end
