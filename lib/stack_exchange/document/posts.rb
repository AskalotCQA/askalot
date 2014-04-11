module StackExchange
  class Document
    class Posts < StackExchange::Document
      def process_element(post, options = {})
        if post[:PostTypeId] == '1'
          user = User.find_by(stack_exchange_uuid: post[:OwnerUserId])

          question = Question.new(
            author_id:           user.nil? ? 0 : user.id,
            category_id:         Category.first.id,
            title:               post[:Title], # TODO (smolnar) make title only 145 characters long, restrictions on DB
            text:                ActionView::Base.full_sanitizer.sanitize(post[:Text]).to_s,
            created_at:          post[:CreationDate],
            updated_at:          post[:CreationDate],
            tag_list:            post[:Tags].gsub(/^</,'').gsub(/>$/,'').split(/></).map { |t| t.downcase.gsub(/[^[:alnum:]]+/, '-').gsub(/\A-|-\z/, '') },
            touched_at:          post[:CreationDate],
            stack_exchange_uuid: post[:Id]
          )

          question.save!(validate: false, timestamps: false)
        end

        if post[:PostTypeId] == '2'
          user     = User.find_by(stack_exchange_uuid: post[:OwnerUserId])
          question = Question.find_by(stack_exchange_uuid: post[:ParentId])

          answer = Answer.new(
            author_id:           user.nil? ? 0 : user.id,
            question_id:         question.nil? ? 0 : question.id,
            text:                ActionView::Base.full_sanitizer.sanitize(post[:Text]).to_s,
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
