class Ability
  include CanCan::Ability

  def initialize(user)
    can :change_name, User unless user.ais_login?

    # TODO (jharinek) define roles like this: 'can :action, Model'
    # TODO (jharinek) see: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    if user.role? :student

    end

    if user.role? :teacher

    end

    if user.role? :administrator

    end
  end
end
