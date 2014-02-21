class Ability
  include CanCan::Ability

  def initialize(user)
    # TODO (smolnar) arrange permission by resource they access
    can :change_name,     User unless user.ais_login?
    can :change_password, User unless user.ais_login?
    can :show_email, User do |resource|
      resource.show_email?
    end

    can :show_name, User do |resource|
      resource.show_name? && resource.name.present?
    end

    can :edit_profile, User do |other|
      other == user
    end

    can :label, [Question, Answer] do |resource|
      resource.author == user
    end

    # TODO (jharinek) define roles like this: 'can :action, Model'
    # TODO (jharinek) see: https://github.com/ryanb/cancan/wiki/Defining-Abilities
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
