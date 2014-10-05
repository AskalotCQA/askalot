class AddFacebookInformationToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :integer
    add_column :users, :provider, :string
    add_column :users, :oauth_token, :text
    add_column :users, :oauth_expires_at, :datetime
  end
end
