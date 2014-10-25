class AddFacebookFriendsAndFacebookLikesToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_friends, :text
    add_column :users, :facebook_likes,   :text
  end
end
