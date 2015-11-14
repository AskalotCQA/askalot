class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :role

  validates :user,     presence: true, uniqueness: { scope: :category }
  validates :category, presence: true, uniqueness: { scope: :user }
  validates :role,     presence: true

  def user_nick=(value)
    user = User.find_by(nick: value)

    return self.user = user if user

    errors.add(:user_nick, :does_not_exists) unless user

    nil
  end

  def user_nick
    user.nick if user
  end
end
