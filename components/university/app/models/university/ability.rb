module University::Ability
  # This module is included in Shared::Ability

  def abilities(user)
    can :index,  [University::Group, University::Document]
    can :create, [University::Group, University::Document]
    can :show,   [University::Group, University::Document]

    # but only if group has no documents, and document has no questions
    cannot(:delete, [University::Group]) { |resource| resource.documents.any? }
    cannot(:delete, [University::Document]) { |resource| resource.questions.any? }

    # TODO (jharinek) consider Authorable
    # only group creator can edit or delete group
    can(:edit,   [University::Group]) { |resource| resource.creator == user }
    can(:delete, [University::Group]) { |resource| resource.creator == user }

    can(:edit,   [University::Document]) { |resource| resource.author == user }
    can(:delete, [University::Document]) { |resource| resource.author == user }

    # only AIS teacher
    if user.role? :teacher
      can :observe, :all

      # TODO (jharinek) refactor when implementing "true" roles for group
      cannot :show,  University::Group, visibility: :private
      cannot :index, University::Group, visibility: :private
    end

    # only AIS administrator
    if user.role? :administrator
      # TODO (jharinek) refactor when implementing "true" roles for group
      can :edit,   [University::Group, University::Document]
      can :delete, [University::Group, University::Document]
    end
  end
end

