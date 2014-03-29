module StackOverflow
  class Processor
    class PostHistory < StackOverflow::Processor
      def process(filepath, options = {})
        parser = Nokogiri::XML::SAX::Parser.new(PostHistoryDocument.new)
        parser.parse(File.open(filepath))
      end
    end
  end
end
