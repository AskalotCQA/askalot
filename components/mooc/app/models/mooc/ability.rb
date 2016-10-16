module Mooc::Ability
  # This module is included in Shared::Ability

  def abilities(user)
    if user.role?(:teacher) || assigned_teacher(user)
      can :teacher_administrate, :all
    end
  end

  private

  def assigned_teacher(user)
    user.assignments.where(assignments: { admin_visible: true }).includes(:role).map { |a| a.role.name }.include? 'teacher'
  end
end

