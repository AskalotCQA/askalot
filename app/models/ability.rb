# see: https://github.com/ryanb/cancan/wiki/Defining-Abilities

class Ability
  include CanCan::Ability

  def initialize(user)
    # TODO(zbell) refactor to use only actions :read, :create, :update and :destroy on models

    can(:edit,   User) { |resource| resource == user }
    can(:follow, User) { |resource| resource != user }

    can(:show_anonymous, User) { |resource| resource == user }
    can(:show_email,     User) { |resource| resource.show_email? }
    can(:show_name,      User) { |resource| resource.show_name? && resource.name.present? }

    can :change_name,     User unless user.ais_login?
    can :change_password, User unless user.ais_login?

    can :create, [Group, Document]

    can :show,  [Group, Document]
    can :index, [Group, Document]

    can :ask,    Question
    can :answer, Question
    can :favor,  Question
    can :view,   Question

    can :comment, [Question, Answer]
    can :vote,    [Question, Answer]

    # user.role? refers exactly and only to AIS role, user.assigned? refers
    # to assigned role for specific category or AIS role if no assignments
    # for specific category exist

    # TODO (jharinek) consider Authorable
    # only group creator can edit or delete group
    can(:edit,   [Group]) { |resource| resource.creator == user}
    can(:delete, [Group]) { |resource| resource.creator == user }

    # only author can edit or delete document, question, answer or comment
    can(:edit,   [Document, Question, Answer, Comment]) { |resource| resource.author == user }
    can(:delete, [Document, Question, Answer, Comment]) { |resource| resource.author == user }

    # but only if question or answer has no evaluations, and answer has no labelings
    cannot(:edit, [Question, Answer]) { |resource| resource.evaluations.any? }
    cannot(:edit, [Answer]) { |resource| resource.labelings.any? }

    # but only if question has no answers, comments and evaluations, and answer has no labels, comments and evaluations
    cannot(:delete, [Question]) { |resource| resource.answers.any? || resource.comments.any? || resource.evaluations.any? }
    cannot(:delete, [Answer]) { |resource| resource.labels.any? || resource.comments.any? || resource.evaluations.any? }

    # but only if group has no documents
    cannot(:delete, [Group]) { |resource| resource.documents.any? }

    # but only if document has no questions
    cannot(:delete, [Document]) { |resource| resource.questions.any? }

    # on the other hand assigned administrator can edit or delete question, answer or comment
    can(:edit,   [Question, Answer, Comment]) { |resource| user.assigned?(resource.to_question.category, :administrator) }
    can(:delete, [Question, Answer, Comment]) { |resource| user.assigned?(resource.to_question.category, :administrator) }

    # only author or assigned teacher when author is slido can label question or answer
    can :label, [Question, Answer] do |resource|
      resource.author == user || (resource.author == User.find_by(login: :slido) && user.assigned?(resource.to_question.category, :teacher))
    end

    # only assigned teacher can evaluate question or answer
    can :evaluate, [Question, Answer] do |resource|
      user.assigned?(resource.to_question.category, :teacher)
    end

    # but assigned teacher can not vote for question or answer
    cannot :vote, [Question, Answer] do |resource|
      user.assigned?(resource.to_question.category, :teacher)
    end

    # only AIS teacher
    if user.role? :teacher
      can :observe, :all

      # TODO (jharinek) refactor when implementing "true" roles for group
      cannot :view,  Group, visibility: :private
      cannot :index, Group, visibility: :private
    end

    # only AIS administrator
    if user.role? :administrator
      can :administrate, :all
      can :observe, :all

      # TODO (jharinek) refactor when implementing "true" roles for group
      can :edit,   [Group, Document]
      can :delete, [Group, Document]

      can :create,  [Assignment, Category, Changelog]
      can :update,  [Assignment, Category, Changelog]
      can :destroy, [Assignment, Category, Changelog]

      can :vote, :all
    end
  end
end
