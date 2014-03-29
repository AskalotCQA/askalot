module StackExchange
  class Processor
    class Users < StackExchange::Processor
      def process(filepath, options = {})
        user = User.find_by(id: 0)

        if user.nil?
          User.create_without_confirmation!(id: 0, login: :anonymous, email: 'anonymous@stackexchange.com', password: 'password', password_confirmation: 'password')
        end

        parser = Nokogiri::XML::SAX::Parser.new(UsersDocument.new)
        parser.parse(File.open(filepath))
      end
    end
  end
end
