# see: https://github.com/ryanb/cancan/wiki/Defining-Abilities

module Shared
class Ability
  include CanCan::Ability
  include (Rails.module.classify + '::Ability').constantize

  def initialize(user)
    # TODO(zbell) refactor to use only actions :read, :create, :update and :destroy on models

    can(:edit,   Shared::User) { |resource| resource == user }
    can(:follow, Shared::User) { |resource| resource != user }

    can(:show_anonymous, Shared::User) { |resource| resource == user }
    can(:show_email,     Shared::User) { |resource| resource.show_email? }
    can(:show_name,      Shared::User) { |resource| resource.show_name? && resource.name.present? }

    can :change_name,     Shared::User unless user.ais_login?
    can :change_password, Shared::User unless user.ais_login?

    can :ask,    Shared::Question
    can :answer, Shared::Question
    can :favor,  Shared::Question
    can :view,   Shared::Question

    can :comment, [Shared::Question, Shared::Answer]
    can :vote,    [Shared::Question, Shared::Answer]

    # user.role? refers exactly and only to AIS role, user.assigned? refers
    # to assigned role for specific category or AIS role if no assignments
    # for specific category exist

    # only author can edit or delete document, question, answer, comment or evaluation
    can(:edit,   [Shared::Question, Shared::Answer, Shared::Comment, Shared::Evaluation]) { |resource| resource.author == user }
    can(:delete, [Shared::Question, Shared::Answer, Shared::Comment, Shared::Evaluation]) { |resource| resource.author == user }

    # but only if question or answer has no evaluations, and answer has no labelings
    cannot(:edit, [Shared::Question, Shared::Answer]) { |resource| resource.evaluations.any? }
    cannot(:edit, [Shared::Answer]) { |resource| resource.labelings.any? }

    # but only if question has no answers, comments and evaluations, and answer has no labels, comments and evaluations
    cannot(:delete, [Shared::Question]) { |resource| resource.answers.any? || resource.comments.any? || resource.evaluations.any? }
    cannot(:delete, [Shared::Answer]) { |resource| resource.labels.any? || resource.comments.any? || resource.evaluations.any? }

    # on the other hand assigned administrator can edit or delete question, answer or comment
    can(:edit,   [Shared::Question, Shared::Answer, Shared::Comment]) { |resource| user.assigned?(resource.to_question.category, :administrator) || user.assigned?(resource.to_question.category, :teacher) }
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

    # assigned teacher can close questions
    can :close, [Shared::Question] do |resource|
      resource.answers.empty? && !resource.closed && user.assigned?(resource.to_question.category, :teacher)
    end

    # only AIS teacher
    if user.role? :teacher
      can :observe, :all
    end

    # only AIS administrator
    if user.role? :administrator
      can :administrate, :all
      can :observe, :all

      can(:close,  [Shared::Question]) { |resource| resource.answers.empty? && !resource.closed }

      can :index,           [Shared::Assignment, Shared::Category, Shared::Changelog, Shared::Email, Shared::New]
      can :new,             [Shared::Category]
      can :edit,            [Shared::Category]
      can :create,          [Shared::Assignment, Shared::Category, Shared::Changelog, Shared::Email, Shared::New]
      can :update,          [Shared::Assignment, Shared::Category, Shared::Changelog, Shared::New]
      can :destroy,         [Shared::Assignment, Shared::Category, Shared::Changelog, Shared::New]
      can :update_settings, [Shared::Category]
      can :copy,            [Shared::Category]

      can :vote, :all
    end

    abilities user
  end
end
end
