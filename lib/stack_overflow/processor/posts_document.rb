module StackOverflow
  class Processor
    class PostsDocument < Nokogiri::XML::SAX::Document
      def initialize type
        @type = type
      end

      def start_document
        puts '[Posts] Start processing'
        @questions = []
        @answers = []
        @count = 0
      end

      def end_document
        Answer.import @answers, :validate => false, :timestamps => false
        puts '[Posts] End processing'
      end

      def start_element(name, attributes = [])
        if name == 'row'
          post = Hash.new
          attributes.each do |attribute|
            post[attribute[0]] = attribute[1]
          end

          # Question
          if @type == :questions && post['PostTypeId'] == '1'
            @count += 1
            puts '[Posts] Processing ' + @count.to_s + '. question with ID: ' + post['Id']

            user = User.find_by_imported_id post['OwnerUserId']

            question = Question.new(
                author_id: user.nil? ? 0 : user.id,
                category_id: 1,
                title: post['Title'],
                text: ActionView::Base.full_sanitizer.sanitize(post['Body']),
                created_at: post['CreationDate'],
                updated_at: post['CreationDate'],
                tag_list: post['Tags'].gsub(/^</,'').gsub(/>$/,'').split(/></),
                imported_id: post['Id']
            )

            @questions << question

            if @questions.count >= 1000
              Question.import @questions, :validate => false, :timestamps => false
              @questions = []
            end
          end

          # Answer
          if @type == :answers && post['PostTypeId'] == '2'
            @count += 1
            puts '[Posts] Processing ' + @count.to_s + '. answer with ID: ' + post['Id']

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

            if @answers.count >= 1000
              Answer.import @answers, :validate => false, :timestamps => false
              @answers = []
            end
          end
        end
      end
    end
  end
end
