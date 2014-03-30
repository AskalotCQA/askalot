require 'securerandom'

module StackExchange
  class Document
    class Users < StackExchange::Document
      def initialize
        @model = User
      end

      def process_element(user)
        return if user[:Id] == '-1'

        user = User.new(
          login:              'user_' + user[:Id],
          email:               SecureRandom.hex + '@stackexchange.com',
          name:                user[:DisplayName],
          created_at:          user[:CreationDate],
          updated_at:          user[:CreationDate],
          last_sign_in_at:     user[:LastAccessDate],
          about:               user[:AboutMe].try(:html_safe),
          stack_exchange_uuid: user[:Id]
        )

        user.skip_confirmation!

        return user
      end
    end
  end
end
