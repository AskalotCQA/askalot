module Shared
class Assignment < ActiveRecord::Base
  belongs_to :user
  belongs_to :category
  belongs_to :role

  after_save :add_assignments_to_descendants
  before_destroy :delete_assignments_from_descendants

  validates :user,     presence: true, uniqueness: { scope: :category }
  validates :category, presence: true, uniqueness: { scope: :user }
  validates :role,     presence: true

  self.table_name = 'assignments'

  def user_nick=(value)
    user = User.find_by(nick: value)

    return self.user = user if user

    errors.add(:user_nick, :does_not_exists) unless user

    nil
  end

  def user_nick
    user.nick if user
  end

  def add_assignments_to_descendants
    return true unless Shared::Assignment.column_names.include? 'admin_visible'

    if admin_visible
      delete_assignments_from_descendants

      category.descendants.each do |c|
        Shared::Assignment.create(role: role, user: user, category: c, admin_visible: false, parent: id)
      end
    end

    true
  end

  def delete_assignments_from_descendants
    return true unless Shared::Assignment.column_names.include? 'admin_visible'

    Shared::Assignment.where({ parent: id }).destroy_all if admin_visible

    true
  end
end
end
