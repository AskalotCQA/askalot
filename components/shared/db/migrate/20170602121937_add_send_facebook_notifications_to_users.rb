class AddSendFacebookNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_facebook_notifications, :boolean

    execute 'UPDATE users SET send_facebook_notifications = true WHERE omniauth_token IS NOT NULL'
  end
end
