# see: https://github.com/ryanb/cancan/wiki/Defining-Abilities

module University
class Ability
  include CanCan::Ability

  def initialize(user)
    # TODO(zbell) refactor to use only actions :read, :create, :update and :destroy on models

    can(:edit,   University::User) { |resource| resource == user }
    can(:follow, University::User) { |resource| resource != user }

    can(:show_anonymous, University::User) { |resource| resource == user }
    can(:show_email,     University::User) { |resource| resource.show_email? }
    can(:show_name,      University::User) { |resource| resource.show_name? && resource.name.present? }

    can :change_name,     University::User unless user.ais_login?
    can :change_password, University::User unless user.ais_login?

    can :index,  [University::Group, University::Document]
    can :create, [University::Group, University::Document]
    can :show,   [University::Group, University::Document]

    can :ask,    University::Question
    can :answer, University::Question
    can :favor,  University::Question
    can :view,   University::Question

    can :comment, [University::Question, University::Answer]
    can :vote,    [University::Question, University::Answer]

    # user.role? refers exactly and only to AIS role, user.assigned? refers
    # to assigned role for specific category or AIS role if no assignments
    # for specific category exist

    # TODO (jharinek) consider Authorable
    # only group creator can edit or delete group
    can(:edit,   [University::Group]) { |resource| resource.creator == user}
    can(:delete, [University::Group]) { |resource| resource.creator == user }

    # only author can edit or delete document, question, answer, comment or evaluation
    can(:edit,   [University::Document, University::Question, University::Answer, University::Comment, University::Evaluation]) { |resource| resource.author == user }
    can(:delete, [University::Document, University::Question, University::Answer, University::Comment, University::Evaluation]) { |resource| resource.author == user }

    # but only if question or answer has no evaluations, and answer has no labelings
    cannot(:edit, [University::Question, University::Answer]) { |resource| resource.evaluations.any? }
    cannot(:edit, [University::Answer]) { |resource| resource.labelings.any? }

    # but only if group has no documents, and document has no questions
    cannot(:delete, [University::Group]) { |resource| resource.documents.any? }
    cannot(:delete, [University::Document]) { |resource| resource.questions.any? }

    # but only if question has no answers, comments and evaluations, and answer has no labels, comments and evaluations
    cannot(:delete, [University::Question]) { |resource| resource.answers.any? || resource.comments.any? || resource.evaluations.any? }
    cannot(:delete, [University::Answer]) { |resource| resource.labels.any? || resource.comments.any? || resource.evaluations.any? }

    # on the other hand assigned administrator can edit or delete question, answer or comment
    can(:edit,   [University::Question, University::Answer, University::Comment]) { |resource| user.assigned?(resource.to_question.category, :administrator) }
    can(:delete, [University::Question, University::Answer, University::Comment]) { |resource| user.assigned?(resource.to_question.category, :administrator) }

    # only author or assigned teacher when author is slido can label question or answer
    can :label, [University::Question, University::Answer] do |resource|
      resource.author == user || (resource.author == University::User.find_by(login: :slido) && user.assigned?(resource.to_question.category, :teacher))
    end

    # only assigned teacher can evaluate question or answer
    can :evaluate, [University::Question, University::Answer] do |resource|
      user.assigned?(resource.to_question.category, :teacher)
    end

    # but assigned teacher can not vote for question or answer
    cannot :vote, [University::Question, University::Answer] do |resource|
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
      can(:close,  [University::Question]) { |resource| resource.answers.empty? && !resource.closed }

      can :create,  [University::Assignment, University::Category, University::Changelog, University::Email]
      can :update,  [University::Assignment, University::Category, University::Changelog]
      can :destroy, [University::Assignment, University::Category, University::Changelog]

      can :vote, :all
    end
  end
end
end
