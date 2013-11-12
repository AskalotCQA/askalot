class Ability
  include CanCan::Ability

  def initialize(user)
    can :change_name, User unless user.ais_login?
  end
end
