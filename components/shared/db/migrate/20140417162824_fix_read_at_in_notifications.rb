class FixReadAtInNotifications < ActiveRecord::Migration
  def up
    Shared::Notification.unscope(where: :resource_type).read.find_each do |notification|
      notification.update_attributes! read_at: notification.updated_at
    end
  end

  def down
  end
end
