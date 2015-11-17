module StackExchange
  class Document
    class Votes < StackExchange::Document
      def initialize(*args)
        super(*args)

        @label = University::Label.find_or_create_by!(value: :best)
      end

      def process_element(vote)
        if vote[:VoteTypeId] == '1'
          answer = StackExchange::Mapper.answers[vote[:PostId]]

          return unless answer
          return if University::Labeling.exists?(answer_id: answer[:id], label_id: @label.id, stack_exchange_uuid: vote[:Id])
          return if @records.find { |record| record.class == University::Labeling && record.label_id == label.id && record.answer_id == question[:id].to_i && record.stack_exchange_uuid == vote[:Id] }

          # TODO fix for some weird dates in SE datasets
          date = Time.parse(vote[:CreationDate]) > answer[:created_at] ? vote[:CreationDate] : answer[:created_at] + 1.minute

          return University::Labeling.create!(
            answer_id:           answer[:id],
            author_id:           0,
            label_id:            @label.id,
            created_at:          date,
            updated_at:          date,
            stack_exchange_uuid: vote[:Id]
          )
        end

        if vote[:VoteTypeId] == '2' || vote[:VoteTypeId] == '3'
          answer        = StackExchange::Mapper.answers[vote[:PostId]]
          question      = StackExchange::Mapper.questions[vote[:PostId]]
          votable       = answer || question
          votable_type  = question.nil? ? 'University::Answer' : 'University::Question'
          positive      = vote[:VoteTypeId] == '2' ? true : false

          return if !answer && !question

          return if University::Vote.exists?(votable_id: votable[:id], votable_type: votable_type, positive: positive, stack_exchange_uuid: vote[:Id])
          return if @records.find { |record| record.class == University::Vote && record.votable_id == votable[:id].to_i && record.votable_type == votable_type && record.positive == positive && record.stack_exchange_uuid == vote[:Id] }

          date = Time.parse(vote[:CreationDate]) > votable[:created_at] ? vote[:CreationDate] : votable[:created_at] + 1.minute

          return University::Vote.new(
            votable_id:          votable[:id],
            votable_type:        votable_type,
            positive:            positive,
            created_at:          date,
            updated_at:          date,
            stack_exchange_uuid: vote[:Id]
          )
        end

        if vote[:VoteTypeId] == '5'
          user     = StackExchange::Mapper.users[vote[:UserId]]
          question = StackExchange::Mapper.questions[vote[:PostId]]

          return if question.nil? || user.nil?
          return if University::Favorite.exists?(stack_exchange_uuid: vote[:Id])
          return if University::Favorite.exists?(favorer_id: user[:id], question_id: question[:id])
          return if @records.find { |record| record.class == University::Favorite && record.favorer_id == user[:id].to_i && record.question_id == question[:id].to_i }

          date = Time.parse(vote[:CreationDate]) > question[:created_at] ? vote[:CreationDate] : question[:created_at] + 1.minute

          return University::Favorite.new(
            favorer_id:          user[:id],
            question_id:         question[:id],
            created_at:          date,
            updated_at:          date,
            stack_exchange_uuid: vote[:Id]
          )
        end

        return nil
      end
    end
  end
end
