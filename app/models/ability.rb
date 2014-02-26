# TODO (jharinek) see: https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    can(:edit, User) { |resource| resource == user }

    can(:show_email, User) { |resource| resource.show_email? }
    can(:show_name,  User) { |resource| resource.show_name? && resource.name.present? }

    can :change_name,     User unless user.ais_login?
    can :change_password, User unless user.ais_login?

    can :ask,    Question
    can :answer, Question

    can :comment, [Question, Answer]
    can :vote,    [Question, Answer]

    can :label, [Question, Answer] do |resource|
      resource.author == user || (user.role?(:teacher) && resource.author == User.find_by(login: :slido))
    end

    if user.role? :student
    end

    if user.role? :teacher
      can :evaluate, [Question, Answer]

      can    :observe, :all
      cannot :vote,    :all
    end

    if user.role? :administrator
      can :manage, :all
    end
  end
end
