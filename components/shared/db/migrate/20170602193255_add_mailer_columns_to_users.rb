class AddMailerColumnsToUsers < ActiveRecord::Migration
  def up
    add_column :users, :send_mail_notifications_frequency, :string, default: 'daily'
    add_column :users, :last_mail_notification_sent_at, :datetime
    add_column :users, :mail_notification_delay, :integer, default: 0

    execute "UPDATE users SET last_mail_notification_sent_at = '#{Date.today + 5.hours}'"
  end

  def down
    remove_column :users, :send_mail_notifications_frequency
    remove_column :users, :last_mail_notification_sent_at
    remove_column :users, :mail_notification_delay
  end
end
