module StackExchange
  class Processor
    class Votes < StackExchange::Processor
      def process(filepath, options = {})
        parser = Nokogiri::XML::SAX::Parser.new(Document::Votes.new)
        parser.parse(File.open(filepath))
      end
    end
  end
end
