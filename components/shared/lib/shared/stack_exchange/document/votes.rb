module Shared::StackExchange
  class Document
    class Votes < Shared::StackExchange::Document
      def initialize(*args)
        super(*args)

        @label = Shared::Label.find_or_create_by!(value: :best)
      end

      def process_element(vote)
        if vote[:VoteTypeId] == '1'
          answer = Shared::StackExchange::Mapper.answers[vote[:PostId]]

          return unless answer
          return if Shared::Labeling.exists?(answer_id: answer[:id], label_id: @label.id, stack_exchange_uuid: vote[:Id])
          return if @records.find { |record| record.class == Shared::Labeling && record.label_id == label.id && record.answer_id == question[:id].to_i && record.stack_exchange_uuid == vote[:Id] }

          # TODO fix for some weird dates in SE datasets
          date = Time.parse(vote[:CreationDate]) > answer[:created_at] ? vote[:CreationDate] : answer[:created_at] + 1.minute

          return Shared::Labeling.create!(
            answer_id:           answer[:id],
            author_id:           0,
            label_id:            @label.id,
            created_at:          date,
            updated_at:          date,
            stack_exchange_uuid: vote[:Id]
          )
        end

        if vote[:VoteTypeId] == '2' || vote[:VoteTypeId] == '3'
          answer        = Shared::StackExchange::Mapper.answers[vote[:PostId]]
          question      = Shared::StackExchange::Mapper.questions[vote[:PostId]]
          votable       = answer || question
          votable_type  = question.nil? ? 'Shared::Answer' : 'Shared::Question'
          positive      = vote[:VoteTypeId] == '2' ? true : false

          return if !answer && !question

          return if Shared::Vote.exists?(votable_id: votable[:id], votable_type: votable_type, positive: positive, stack_exchange_uuid: vote[:Id])
          return if @records.find { |record| record.class == Shared::Vote && record.votable_id == votable[:id].to_i && record.votable_type == votable_type && record.positive == positive && record.stack_exchange_uuid == vote[:Id] }

          date = Time.parse(vote[:CreationDate]) > votable[:created_at] ? vote[:CreationDate] : votable[:created_at] + 1.minute

          return Shared::Vote.new(
            votable_id:          votable[:id],
            votable_type:        votable_type,
            positive:            positive,
            created_at:          date,
            updated_at:          date,
            stack_exchange_uuid: vote[:Id]
          )
        end

        if vote[:VoteTypeId] == '5'
          user     = Shared::StackExchange::Mapper.users[vote[:UserId]]
          question = Shared::StackExchange::Mapper.questions[vote[:PostId]]

          return if question.nil? || user.nil?
          return if Shared::Favorite.exists?(stack_exchange_uuid: vote[:Id])
          return if Shared::Favorite.exists?(favorer_id: user[:id], question_id: question[:id])
          return if @records.find { |record| record.class == Shared::Favorite && record.favorer_id == user[:id].to_i && record.question_id == question[:id].to_i }

          date = Time.parse(vote[:CreationDate]) > question[:created_at] ? vote[:CreationDate] : question[:created_at] + 1.minute

          return Shared::Favorite.new(
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
