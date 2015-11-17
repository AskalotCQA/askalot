require 'securerandom'

module StackExchange
  class Document
    class Users < StackExchange::Document
      def from
        nil
      end

      def to
        nil
      end

      def process_element(user)
        return if user[:Id] == '-1'

        return if Shared::User.exists?(stack_exchange_uuid: user[:Id])

        user = Shared::User.new(
          login:              'user_' + user[:Id],
          email:               SecureRandom.hex + '@stackexchange.com',
          name:                user[:DisplayName],
          created_at:          user[:CreationDate],
          updated_at:          user[:CreationDate],
          last_sign_in_at:     user[:LastAccessDate],
          about:               ActionView::Base.full_sanitizer.sanitize(user[:AboutMe]).to_s,
          stack_exchange_uuid: user[:Id]
        )

        user.skip_confirmation!

        return user
      end
    end
  end
end
