module StackOverflow
  class Processor
    class Posts < StackOverflow::Processor
      def process(filepath, options = {})
        category = Category.first
        if category.nil?
          Category.create(
              name: 'Stack Overflow'
          )
        end

        parser = Nokogiri::XML::SAX::Parser.new(PostsDocument.new :questions)
        parser.parse(File.open(filepath))

        parser = Nokogiri::XML::SAX::Parser.new(PostsDocument.new :answers)
        parser.parse(File.open(filepath))
      end
    end
  end
end