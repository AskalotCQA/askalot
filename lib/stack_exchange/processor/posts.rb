module StackExchange
  class Processor
    class Posts < StackExchange::Processor
      def process(path, options = {})
        category = Category.first

        Category.create!(name: 'Stack Overflow') if category.nil?

        parser = Nokogiri::XML::SAX::Parser.new(Document::Posts.new)
        parser.parse(File.open(path))
      end
    end
  end
end
