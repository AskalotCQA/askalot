module Mooc::Ability
  # This module is included in Shared::Ability

  def abilities(user)
    if user.role? :teacher
      can :teacher_administrate, :all
    end
  end
end

