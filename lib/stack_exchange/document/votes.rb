module StackExchange
  class Document
    class Votes < StackExchange::Document
      def process_element(vote)
        if vote[:VoteTypeId] == '1'
          answer = Answer.find_by(stack_exchange_uuid: vote[:PostId])

          answer.toggle_labeling_by! answer.question.author, :best  unless answer.nil? || answer.question.nil? || answer.question.author.nil?
        end

        if vote[:VoteTypeId] == '2' || vote[:VoteTypeId] == '3'
          answer   = Answer.find_by(stack_exchange_uuid: vote[:PostId])
          question = Question.find_by(stack_exchange_uuid: vote[:PostId]) if answer.nil?

          # TODO (smolnar) consider removing index on voter_id, votable_id, voteable_type or
          # use random user who did not vote for resource yet.

          vote = Vote.new(
            voter_id:     0,
            votable_id:   question.nil? ? (answer.nil? ? 0 : answer.id) : question.id,
            votable_type: question.nil? ? :Answer : :Question,
            positive:     vote[:VoteTypeId] == '2' ? true : false,
            created_at:   vote[:CreationDate],
            updated_at:   vote[:CreationDate],
          )

          return vote
        end

        if vote[:VoteTypeId] == '5'
          user     = User.find_by(stack_exchange_uuid: vote[:UserId])
          question = Question.find_by(stack_exchange_uuid: vote[:PostId])

          question.toggle_favoring_by! user unless question.nil? || user.nil?
        end
      end
    end
  end
end
