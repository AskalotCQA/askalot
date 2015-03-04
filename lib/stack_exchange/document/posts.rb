module StackExchange
  class Document
    class Posts < StackExchange::Document
      def initialize(type)
        super()

        @type = type
      end

      def process_element(post, options = {})
        if @type == :question && post[:PostTypeId] == '1'
          return if Question.exists?(stack_exchange_uuid: post[:Id])
          user = Mapper.users[post[:OwnerUserId]] || User.first

          question = Question.new(
            author_id:           user[:id],
            category:            Category.first,
            title:               post[:Title], # TODO (smolnar) make title only 145 characters long, restrictions on DB
            text:                ActionView::Base.full_sanitizer.sanitize(post[:Body]).to_s,
            created_at:          post[:CreationDate],
            updated_at:          post[:CreationDate],
            touched_at:          post[:CreationDate],
            votes_difference:    post[:Score],
            stack_exchange_uuid: post[:Id]
          )

          return question
        end

        if @type == :answer && post[:PostTypeId] == '2'
          user     = Mapper.users[post[:OwnerUserId]]
          question = Mapper.questions[post[:ParentId]]

          return if user.nil? || question.nil?

          return if Answer.exists?(stack_exchange_uuid: post[:Id])

          answer = Answer.new(
            author_id:           user[:id],
            question_id:         question[:id],
            text:                ActionView::Base.full_sanitizer.sanitize(post[:Body]).to_s,
            created_at:          post[:CreationDate],
            updated_at:          post[:CreationDate],
            votes_difference:    post[:Score],
            stack_exchange_uuid: post[:Id]
          )

          return answer
        end

        if @type == :tagging && post[:PostTypeId] == '1'
          tags = post[:Tags].gsub(/^</,'').gsub(/>$/,'').split(/></).map do |t|
            t.downcase.gsub(/[^[:alnum:]#\-\+\.]+/, '-').gsub(/\A-|-\z/, '')
          end

          taggings = tags.uniq.map do |name|
            user_id     = Mapper.users[post[:OwnerUserId]] ? Mapper.users[post[:OwnerUserId]][:id] : User.first.id
            tag_id      = Mapper.tags[name] ? Mapper.tags[name][:id] : Tag.create!(name: name).id
            question_id = Mapper.questions[post[:Id]][:id]

            Mapper.tags[name] ||= { id: tag_id }

            Tagging.new(
              tag_id:      tag_id,
              question_id: question_id,
              author_id:   user_id,
              created_at:  post[:CreationDate],
              updated_at:  post[:CreationDate]
            )
          end

          return taggings.compact
        end
      end
    end
  end
end
