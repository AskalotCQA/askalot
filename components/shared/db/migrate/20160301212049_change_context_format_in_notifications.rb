class ChangeContextFormatInNotifications < ActiveRecord::Migration
  def up
    remove_column :notifications, :context
    add_column :notifications, :context, :integer

    context = Shared::Context::Manager.current_context

    Shared::Notification.unscoped.find_each do |notification|
      notification.context = context

      notification.save!
    end
  end

  def down
    remove_column :notifications, :context
    add_column :notifications, :context, :string
  end
end
