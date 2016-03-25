module Shared
class Role < ActiveRecord::Base
  has_many :assignments, dependent: :restrict_with_exception
  has_many :users, through: :assignments
  has_many :categories, through: :assignments

  validates :name, presence: true

  self.table_name = 'roles'

  def self.teacher_roles
    # TODO (ladislav.gallay) Move to mooc model
    if Rails.module.mooc?
      @@teacher_roles ||= Role::where(name: [:teacher, :teacher_assistant])
    else
      @@teacher_roles ||= Role::where(name: [:teacher])
    end
  end

  def self.teacher_assistant
    @@teacher_assistant_role ||= Role::where(name: :teacher_assistant).first
  end
end
end
