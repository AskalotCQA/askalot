module StackOverflow
  class Processor
    class PostsDocument < Nokogiri::XML::SAX::Document
      def start_document
        puts '[Posts] Start processing'
        @answers = []
      end

      def end_document
        Answer.import @answers, :validate => false, :timestamps => false
        puts '[Posts] End processing'
      end

      def start_element name, attributes = []
        if name == 'row'
          post = Hash.new
          attributes.each do |attribute|
            post[attribute[0]] = attribute[1]
          end

          puts '[Posts] Processing post with ID: ' + post['Id']

          # Question
          if post['PostTypeId'] == '1'
            user = User.find_by_imported_id post['OwnerUserId']

            question = Question.create!(
                author_id: user.nil? ? 0 : user.id,
                category_id: 1,
                title: post['Title'],
                text: ActionView::Base.full_sanitizer.sanitize(post['Body']),
                created_at: post['CreationDate'],
                updated_at: post['CreationDate'],
                tag_list: post['Tags'].gsub(/^</,'').gsub(/>$/,'').split(/></),
                imported_id: post['Id']
            )
          end


          # Answer
          if post['PostTypeId'] == '2'
            user = User.find_by_imported_id post['OwnerUserId']
            question = Question.find_by_imported_id post['ParentId']

            answer = Answer.new(
                author_id: user.nil? ? 0 : user.id,
                question_id: question.nil? ? 0 : question.id,
                text: ActionView::Base.full_sanitizer.sanitize(post['Body'].gsub('/</p> <p>/','\n')),
                created_at: post['CreationDate'],
                updated_at: post['CreationDate'],
                imported_id: post['Id']
            )

            @answers << answer

            if @answers.count > 1000
              Answer.import @answers, :validate => false, :timestamps => false
              @answers = []
            end
          end
        end
      end
    end
  end
end