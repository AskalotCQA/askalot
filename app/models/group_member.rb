class GroupMember < ActiveRecord::Base
  ROLES = [:owner, :member]

  belongs_to :group
  belongs_to :user
  belongs_to :role

  symbolize :role, in: ROLES
end
