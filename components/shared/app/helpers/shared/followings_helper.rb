module Shared::FollowingsHelper
  def link_to_following(following, options = {})
    link_to_user following.follower
  end
end