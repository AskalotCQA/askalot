module Mooc
  class User < Shared::User
    before_create :hide_email

    def default_askalot_page_url
      self.context_users.first.context.askalot_page_url
    end

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

    def hide_email
      self.show_email = false

      true
    end
  end
end
