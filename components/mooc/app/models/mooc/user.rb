module Mooc
  class User < Shared::User
    before_create :hide_email

    protected

    def self.create_without_confirmation!(attributes)
      user = User.new(attributes)

      user.skip_confirmation!
      user.save!
      puts 'saved'
      user
    end

    def password_required?
      false
    end

    def hide_email
      self.show_email = false
    end
  end
end
