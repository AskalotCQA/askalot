module StackOverflow
  class Processor
    class Votes < StackOverflow::Processor
      def process(filepath, options = {})
        parser = Nokogiri::XML::SAX::Parser.new(VotesDocument.new)
        parser.parse(File.open(filepath))
      end
    end
  end
end