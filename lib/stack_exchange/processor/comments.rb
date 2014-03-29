module StackExchange
  class Processor
    class Comments < StackExchange::Processor
      def process(filepath, options = {})
        parser = Nokogiri::XML::SAX::Parser.new(Document::Comments.new)
        parser.parse(File.open(filepath))
      end
    end
  end
end
