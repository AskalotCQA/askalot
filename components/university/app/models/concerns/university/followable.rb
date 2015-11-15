module University::Followable
  extend ActiveSupport::Concern

  included do
    has_many :followings, foreign_key: :follower_id, dependent: :destroy
    has_many :reverse_followings, foreign_key: :followee_id, class_name: :Following, dependent: :destroy

    has_many :followees, through: :followings, source: :followee
    has_many :followers, through: :reverse_followings, source: :follower
  end

  def following?(user)
    followings.exists?(followee: user)
  end

  def follow!(user)
    followings.deleted_or_new(follower: self, followee: user).mark_as_undeleted!
  end

  def unfollow!(user)
    followings.where(follower: self, followee: user).first.mark_as_deleted_by! user
  end

  def toggle_following_by!(user)
    following?(user) ? unfollow!(user) : follow!(user)
  end
end
