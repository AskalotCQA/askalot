module Mooc
class User < Shared::User

  def password_required?
    false
  end
end
end
