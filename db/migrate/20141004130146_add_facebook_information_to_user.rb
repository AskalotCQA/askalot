class AddFacebookInformationToUser < ActiveRecord::Migration
  def change
    add_column :users, :omniauth_provider, :string
    add_column :users, :omniauth_token, :text
    add_column :users, :omniauth_token_expires_at, :datetime

    add_column :users, :facebook_uid, :integer
  end

  add_index :users, :facebook_uid
end
