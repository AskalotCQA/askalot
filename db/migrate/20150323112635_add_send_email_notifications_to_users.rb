class AddSendEmailNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :send_email_notifications, :boolean, default: true, null: false
  end
end
