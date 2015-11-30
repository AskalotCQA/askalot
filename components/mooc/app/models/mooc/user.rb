module Mooc
class User < Shared::User

  def password_required?
    return false
  end
end
end
