module StackExchange
  class Processor
    class Posts < StackExchange::Processor
      def process(path, options = {})
        category = Category.first

        Category.create!(name: 'Stack Overflow') if category.nil?

        parser = Nokogiri::XML::SAX::Parser.new(Document::Posts.new(Question))
        parser.parse(File.open(path))

        parser = Nokogiri::XML::SAX::Parser.new(Document::Posts.new(Answer))
        parser.parse(File.open(path))
      end
    end
  end
end
