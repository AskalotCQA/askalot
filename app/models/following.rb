class Following < ActiveRecord::Base
  belongs_to :follower, class_name: :User, counter_cache: :followees_count
  belongs_to :followee, class_name: :User, counter_cache: :followers_count

  validates :follower_id, presence: true
  validates :followee_id, presence: true

  scope :by, lambda { |user| where(follower: user) }
end
