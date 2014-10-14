class AddFacebookInformationToUser < ActiveRecord::Migration
  def change
    add_column :users, :facebook_uid, :integer
    add_column :users, :auth_provider, :string
    add_column :users, :auth_token, :text
    add_column :users, :auth_token_expires_at, :datetime
  end
end
