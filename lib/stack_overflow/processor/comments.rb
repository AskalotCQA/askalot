module StackOverflow
  class Processor
    class Comments < StackOverflow::Processor
      def process(filepath, options = {})
        parser = Nokogiri::XML::SAX::Parser.new(CommentsDocument.new)
        parser.parse(File.open(filepath))
      end
    end
  end
end