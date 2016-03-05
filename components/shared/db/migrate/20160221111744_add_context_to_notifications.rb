class AddContextToNotifications < ActiveRecord::Migration
  def up
    add_column :notifications, :context, :integer

    context = Shared::Context::Manager.current_context

    ActiveRecord::Base.connection.execute("update notifications set context = #{context}")
  end

  def down
    remove_column :notifications, :context
  end
end