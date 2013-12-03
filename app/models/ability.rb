class Ability
  include CanCan::Ability

  def initialize(user)
    can :change_name, User unless user.ais_login?

    if user.role? :student

    end

    if user.role? :teacher

    end

    if user.role? :administrator

    end
  end
end
