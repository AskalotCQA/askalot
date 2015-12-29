module Mooc
  class User < Shared::User
    protected

    def self.create_without_confirmation!(attributes)
      user = User.new(attributes)

      user.skip_confirmation!
      user.save!
      user
    end

    def password_required?
      false
    end
  end
end
