# TODO (jharinek) see: https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    can(:edit,   User) { |resource| resource == user }
    can(:follow, User) { |resource| resource != user }

    can(:edit,   [Question, Answer, Comment]) { |resource| resource.author == user }
    can(:delete, [Question, Answer, Comment]) { |resource| resource.author == user }

    cannot(:edit, [Question, Answer]) { |resource| resource.evaluations.any? }
    cannot(:edit, [Answer]) { |resource| resource.labelings.any? }

    cannot(:delete, [Question]) { |resource| resource.answers.any? || resource.comments.any? || resource.evaluations.any? }
    cannot(:delete, [Answer]) { |resource| resource.labels.any? || resource.comments.any? || resource.evaluations.any? }

    can(:show_email, User) { |resource| resource.show_email? }
    can(:show_name,  User) { |resource| resource.show_name? && resource.name.present? }

    can :change_name,     User unless user.ais_login?
    can :change_password, User unless user.ais_login?

    can :ask,    Question
    can :answer, Question
    can :favor,  Question
    can :view,   Question

    can :comment, [Question, Answer]
    can :vote,    [Question, Answer]

    can :label, [Question, Answer] do |resource|
      resource.author == user || (user.role?(:teacher) && resource.author == User.find_by(login: :slido))
    end

    if user.role? :teacher
      can :observe, :all
    end

    can(:evaluate, [Question, Answer]) { |resource| user.assignment?(:teacher, resource.to_question.category) }
    cannot(:vote, :all)                { |resource| user.assignment?(:teacher, resource.to_question.category) }

    can(:delete, [Question, Answer, Comment]) { |resource| user.assignment?(:administrator, resource.to_question.category) }
    can(:vote, :all)                          { |resource| user.assignment?(:administrator, resource.to_question.category) }
    can(:edit, [Question, Answer, Comment])   { |resource| user.assignment?(:administrator, resource.to_question.category) }
  end
end
