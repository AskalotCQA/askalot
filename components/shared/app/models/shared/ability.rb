# see: https://github.com/ryanb/cancan/wiki/Defining-Abilities

module Shared
class Ability
  include CanCan::Ability

  def initialize(user)
    # TODO(zbell) refactor to use only actions :read, :create, :update and :destroy on models

    can(:edit,   Shared::User) { |resource| resource == user }
    can(:follow, Shared::User) { |resource| resource != user }

    can(:show_anonymous, Shared::User) { |resource| resource == user }
    can(:show_email,     Shared::User) { |resource| resource.show_email? }
    can(:show_name,      Shared::User) { |resource| resource.show_name? && resource.name.present? }

    can :change_name,     Shared::User unless user.ais_login?
    can :change_password, Shared::User unless user.ais_login?

    can :index,  [University::Group, University::Document]
    can :create, [University::Group, University::Document]
    can :show,   [University::Group, University::Document]

    can :ask,    Shared::Question
    can :answer, Shared::Question
    can :favor,  Shared::Question
    can :view,   Shared::Question

    can :comment, [Shared::Question, Shared::Answer]
    can :vote,    [Shared::Question, Shared::Answer]

    # user.role? refers exactly and only to AIS role, user.assigned? refers
    # to assigned role for specific category or AIS role if no assignments
    # for specific category exist

    # TODO (jharinek) consider Authorable
    # only group creator can edit or delete group
    can(:edit,   [University::Group]) { |resource| resource.creator == user }
    can(:delete, [University::Group]) { |resource| resource.creator == user }

    # only author can edit or delete document, question, answer, comment or evaluation
    can(:edit,   [University::Document, Shared::Question, Shared::Answer, Shared::Comment, Shared::Evaluation]) { |resource| resource.author == user }
    can(:delete, [University::Document, Shared::Question, Shared::Answer, Shared::Comment, Shared::Evaluation]) { |resource| resource.author == user }

    # but only if question or answer has no evaluations, and answer has no labelings
    cannot(:edit, [Shared::Question, Shared::Answer]) { |resource| resource.evaluations.any? }
    cannot(:edit, [Shared::Answer]) { |resource| resource.labelings.any? }

    # but only if group has no documents, and document has no questions
    cannot(:delete, [University::Group]) { |resource| resource.documents.any? }
    cannot(:delete, [University::Document]) { |resource| resource.questions.any? }

    # but only if question has no answers, comments and evaluations, and answer has no labels, comments and evaluations
    cannot(:delete, [Shared::Question]) { |resource| resource.answers.any? || resource.comments.any? || resource.evaluations.any? }
    cannot(:delete, [Shared::Answer]) { |resource| resource.labels.any? || resource.comments.any? || resource.evaluations.any? }

    # on the other hand assigned administrator can edit or delete question, answer or comment
    can(:edit,   [Shared::Question, Shared::Answer, Shared::Comment]) { |resource| user.assigned?(resource.to_question.category, :administrator) }
    can(:delete, [Shared::Question, Shared::Answer, Shared::Comment]) { |resource| user.assigned?(resource.to_question.category, :administrator) }

    # only author or assigned teacher when author is slido can label question or answer
    can :label, [Shared::Question, Shared::Answer] do |resource|
      resource.author == user || (resource.author == Shared::User.find_by(login: :slido) && user.assigned?(resource.to_question.category, :teacher))
    end

    # only assigned teacher can evaluate question or answer
    can :evaluate, [Shared::Question, Shared::Answer] do |resource|
      user.assigned?(resource.to_question.category, :teacher)
    end

    # but assigned teacher can not vote for question or answer
    cannot :vote, [Shared::Question, Shared::Answer] do |resource|
      user.assigned?(resource.to_question.category, :teacher)
    end

    # only AIS teacher
    if user.role? :teacher
      can :observe, :all

      # TODO (jharinek) refactor when implementing "true" roles for group
      cannot :show,  University::Group, visibility: :private
      cannot :index, University::Group, visibility: :private
    end

    # only AIS administrator
    if user.role? :administrator
      can :administrate, :all
      can :observe, :all

      # TODO (jharinek) refactor when implementing "true" roles for group
      can :edit,   [University::Group, University::Document]
      can :delete, [University::Group, University::Document]
      can(:close,  [Shared::Question]) { |resource| resource.answers.empty? && !resource.closed }

      can :create,  [Shared::Assignment, Shared::Category, Shared::Changelog, Shared::Email]
      can :update,  [Shared::Assignment, Shared::Category, Shared::Changelog]
      can :destroy, [Shared::Assignment, Shared::Category, Shared::Changelog]

      can :vote, :all
    end
  end
end
end
