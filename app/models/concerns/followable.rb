module Followable
  extend ActiveSupport::Concern

  included do
    has_many :reverse_followings, foreign_key: :followee_id, class_name: :Following, dependent: :destroy
    has_many :followings, foreign_key: :follower_id, dependent: :destroy

    has_many :followees, through: :followings, source: :followee
    has_many :followers, through: :reverse_followings, source: :follower
  end

  def toggle_following_by!(user)
    return follow! user unless following?(user)
    unfollow! user
  end

  def following?(user)
    followings.exists?(followee: user)
  end

  def follow!(user)
    followings.create!(followee: user)
  end

  def unfollow!(user)
    followings.find_by(followee: user).destroy!
  end
end
