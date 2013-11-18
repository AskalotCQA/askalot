module UsersHelper
  def link_to_user(user, options = {})
    link_to user.nick, user_path(user.nick), options
  end
end
