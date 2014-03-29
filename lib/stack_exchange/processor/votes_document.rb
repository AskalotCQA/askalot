module StackOverflow
  class Processor
    class VotesDocument < Nokogiri::XML::SAX::Document
      def start_document
        puts '[Votes] Start processing'
        @votes = []
        @count = 0
      end

      def end_document
        Vote.import @votes, :validate => false, :timestamps => false
        puts '[Votes] End processing'
      end

      def start_element name, attributes = []
        if name == 'row'
          vote = Hash.new
          attributes.each do |attribute|
            vote[attribute[0]] = attribute[1]
          end

          @count += 1
          puts '[Votes] Processing ' + @count.to_s + '. vote with ID: ' + vote['Id'] + ', type: ' + vote['VoteTypeId']

          if vote['VoteTypeId'] == '1'
            answer = Answer.find_by_imported_id vote['PostId']
            answer.toggle_labeling_by! answer.question.author, :best  unless answer.nil? || answer.question.nil? || answer.question.author.nil?
          end

          # CREATE UNIQUE INDEX index_votes_on_unique_key
          # ON votes
          # USING btree
          # (voter_id, votable_id, votable_type COLLATE pg_catalog."default");

          if vote['VoteTypeId'] == '2' || vote['VoteTypeId'] == '3'
            answer = Answer.find_by_imported_id vote['PostId']
            question = Question.find_by_imported_id vote['PostId'] if answer.nil?

            vote = Vote.new(
                voter_id: 0,
                votable_id: question.nil? ? (answer.nil? ? 0 : answer.id) : question.id,
                votable_type: question.nil? ? 'Answer' : 'Question',
                positive: vote['VoteTypeId'] == '2' ? true : false,
                created_at: vote['CreationDate'],
                updated_at: vote['CreationDate'],
            )

            @votes << vote

            if @votes.count >= 10000
              Vote.import @votes, :validate => false, :timestamps => false
              @votes = []
            end
          end

          if vote['VoteTypeId'] == '5'
            user = User.find_by_imported_id vote['UserId']
            question = Question.find_by_imported_id vote['PostId']
            question.toggle_favoring_by! user unless question.nil? || user.nil?
          end
        end
      end
    end
  end
end
