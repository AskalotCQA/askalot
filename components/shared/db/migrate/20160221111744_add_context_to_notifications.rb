class AddContextToNotifications < ActiveRecord::Migration
  def up
    add_column :notifications, :context, :string

    Shared::Notification.unscoped.find_each do |notification|
      notification.context = Shared::ApplicationHelper.current_context

      notification.save!
    end
  end

  def down
    remove_column :notifications, :context
  end
end
