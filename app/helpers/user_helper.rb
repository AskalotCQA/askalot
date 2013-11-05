module UserHelper
  def user_name(user)
      "#{user.first} #{user.middle} #{user.last}".squeeze(' ')
  end
end