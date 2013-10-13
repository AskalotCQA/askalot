class Ability
  include CanCan::Ability

  def initialize(user)
    can :read, User do
      user.present?
    end

    can :edit, User do |u|
      u == user
    end
  end
end
