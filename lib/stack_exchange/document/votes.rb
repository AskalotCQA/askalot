module StackExchange
  class Document
    class Votes < StackExchange::Document
      def process_element(vote)
        if vote[:VoteTypeId] == '1'
          answer = Answer.find_by(stack_exchange_uuid: vote[:PostId])

          return if answer.nil? || answer.question.nil? || answer.question.author.nil?

          return if Labeling.exists?(stack_exchange_uuid: vote[:Id])

          author = answer.question.author
          label  = Label.find_or_create_by!(value: :best)
          date   = Time.parse(vote[:CreationDate]) > answer.created_at ? vote[:CreationDate] : answer.created_at + 1.minute

          return if Labeling.exists?(answer: answer, author: author, label: label)

          return Labeling.create!(
            answer:              answer,
            author:              author,
            label:               label,
            created_at:          date,
            updated_at:          date,
            stack_exchange_uuid: vote[:Id]
          )
        end

        if vote[:VoteTypeId] == '2' || vote[:VoteTypeId] == '3'
          answer   = Answer.find_by(stack_exchange_uuid: vote[:PostId])
          question = Question.find_by(stack_exchange_uuid: vote[:PostId]) if answer.nil?

          # TODO (smolnar) consider removing index on voter_id, votable_id, voteable_type or
          # use random user who did not vote for resource yet.

          votable  = question.nil? ? answer : question
          positive = vote[:VoteTypeId] == '2' ? true : false

          return unless votable

          date = Time.parse(vote[:CreationDate]) > votable.created_at ? vote[:CreationDate] : votable.created_at + 1.minute

          return if Vote.exists?(stack_exchange_uuid: vote[:Id])

          return Vote.create!(
            votable:             votable,
            positive:            positive,
            created_at:          date,
            updated_at:          date,
            stack_exchange_uuid: vote[:Id]
          )
        end

        if vote[:VoteTypeId] == '5'
          user     = User.find_by(stack_exchange_uuid: vote[:UserId])
          question = Question.find_by(stack_exchange_uuid: vote[:PostId])

          return if question.nil? || user.nil?

          return if Favorite.exists?(stack_exchange_uuid: vote[:Id])
          return if Favorite.exists?(favorer: user, question: question)

          date = Time.parse(vote[:CreationDate]) > question.created_at ? vote[:CreationDate] : question.created_at + 1.minute

          return Favorite.create!(
            favorer:             user,
            question:            question,
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
