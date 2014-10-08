class GroupMember < ActiveRecord::Base
  ROLES = [:owner, :member]

  has_many :groups
  has_many :users

  validates :group_id, presence: true
  validates :user_id,  presence: true

  validates :role, presence: true

  symbolize :role, in: ROLES
end
