module StackOverflow
  class Processor
    class Users < StackOverflow::Processor
      def process(filepath, options = {})
        parser = Nokogiri::XML::SAX::Parser.new(UsersDocument.new)
        parser.parse(File.open(filepath))
      end
    end
  end
end