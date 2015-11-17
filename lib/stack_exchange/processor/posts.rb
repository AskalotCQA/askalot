module StackExchange
  class Processor
    class Posts < StackExchange::Processor
      def process(path, options = {})
        category = Shared::Category.first

        Shared::Category.create!(name: 'Stack Overflow') if category.nil?

        parser = Nokogiri::XML::SAX::Parser.new(Document::Posts.new(:question))
        parser.parse(File.open(path))

        parser = Nokogiri::XML::SAX::Parser.new(Document::Posts.new(:answer))
        parser.parse(File.open(path))

        parser = Nokogiri::XML::SAX::Parser.new(Document::Posts.new(:tagging))
        parser.parse(File.open(path))
      end
    end
  end
end
