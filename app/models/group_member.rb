class GroupMember < ActiveRecord::Base
  ROLES = [:owner, :member]

  belongs_to :group
  belongs_to :user
  belongs_to :role

  # TODO (jharinek) remove
  validates :group_id, presence: true
  validates :user_id,  presence: true
  validates :role_id,  presence: true

  symbolize :role, in: ROLES
end
