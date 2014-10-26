# see: https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    # TODO(zbell) refactor to use only actions :read, :create, :update and :destroy on models

    can(:edit,   User) { |resource| resource == user }
    can(:follow, User) { |resource| resource != user }

    can(:edit,   [Question, Answer, Comment]) { |resource| resource.author == user }
    can(:delete, [Question, Answer, Comment]) { |resource| resource.author == user }

    cannot(:edit, [Question, Answer]) { |resource| resource.evaluations.any? }
    cannot(:edit, [Answer]) { |resource| resource.labelings.any? }

    cannot(:delete, [Question]) { |resource| resource.answers.any? || resource.comments.any? || resource.evaluations.any? }
    cannot(:delete, [Answer]) { |resource| resource.labels.any? || resource.comments.any? || resource.evaluations.any? }

    can(:show_anonymous, User) { |resource| resource == user }
    can(:show_email,     User) { |resource| resource.show_email? }
    can(:show_name,      User) { |resource| resource.show_name? && resource.name.present? }

    can :change_name,     User unless user.ais_login?
    can :change_password, User unless user.ais_login?

    can :ask,    Question
    can :answer, Question
    can :favor,  Question
    can :view,   Question

    can :comment, [Question, Answer]
    can :vote,    [Question, Answer]

    can :label, [Question, Answer] do |resource|
      resource.author == user || (resource.author == User.find_by(login: :slido) && user.assigned?(resource.to_question.category, :teacher))
    end

    can :evaluate, [Question, Answer] do |resource|
      user.assigned?(resource.to_question.category, :teacher)
    end

    can :vote, [Question, Answer] do |resource|
      !user.assigned?(resource.to_question.category, :teacher)
    end

    if user.role? :teacher
      can :observe, :all
    end

    if user.role? :administrator
      can :administrate, :all

      can :edit,   [Question, Answer, Comment]
      can :delete, [Question, Answer, Comment]

      can :create,  [Assignment, Category, Changelog]
      can :update,  [Assignment, Category, Changelog]
      can :destroy, [Assignment, Category, Changelog]

      can :vote, :all
    end
  end
end
