class Ability
  include CanCan::Ability

  def initialize(user)
    can :edit, [Question, Answer] do |resource|
      resource.author == user
    end

    can :change_name, User unless user.ais_login?

    # TODO (jharinek) define roles like this: 'can :action, Model'
    # TODO (jharinek) see: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    if user.role? :student
    end

    if user.role? :teacher
      can :observe, nil
      can :verify, Answer
    end

    if user.role? :administrator
    end
  end
end
