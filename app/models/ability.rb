class Ability
  include CanCan::Ability

  def initialize(user)
    can :change_name,     User unless user.ais_login?
    can :change_password, User unless user.ais_login?

    can :edit, [Question, Answer] do |resource|
      resource.author == user || (user.role?(:teacher) && resource.author == User.where("login='slido'")[0])
    end

    # TODO (jharinek) define roles like this: 'can :action, Model'
    # TODO (jharinek) see: https://github.com/ryanb/cancan/wiki/Defining-Abilities
    # TODO (jharinek) propose change ability 'edit' to e.g. 'label'
    if user.role? :student
    end

    if user.role? :teacher
      can :observe, :all
      can :evaluate, [Question, Answer]
    end

    if user.role? :administrator
    end
  end
end
