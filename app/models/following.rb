class Following < ActiveRecord::Base
  #include Deletable #TODO enable
  include Notifiable

  belongs_to :follower, class_name: :User, counter_cache: :followees_count
  belongs_to :followee, class_name: :User, counter_cache: :followers_count

  validates :followee_id, presence: true
  validates :follower_id, presence: true
end
