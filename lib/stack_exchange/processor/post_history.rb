module StackExchange
  class Processor
    class PostHistory < StackExchange::Processor
      def process(filepath, options = {})
        parser = Nokogiri::XML::SAX::Parser.new(Document::PostHistory.new)
        parser.parse(File.open(filepath))
      end
    end
  end
end
