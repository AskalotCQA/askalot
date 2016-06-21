module Shared
class Role < ActiveRecord::Base
  has_many :assignments, dependent: :restrict_with_exception
  has_many :users, through: :assignments
  has_many :categories, through: :assignments

  validates :name, presence: true

  self.table_name = 'roles'

  def self.teacher_roles
    roles           = Rails.module.mooc? ? [:teacher, :teacher_assistant] : [:teacher]
    @@teacher_roles ||= Role::where(name: roles)
  end

  def self.teacher_assistant
    @@teacher_assistant_role ||= Role::where(name: :teacher_assistant).first
  end
end
end
