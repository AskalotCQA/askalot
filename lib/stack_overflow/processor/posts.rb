module StackOverflow
  class Processor
    class Posts < StackOverflow::Processor
      def process(filepath, options = {})
        parser = Nokogiri::XML::SAX::Parser.new(PostsDocument.new)
        parser.parse(File.open(filepath))
      end
    end
  end
end