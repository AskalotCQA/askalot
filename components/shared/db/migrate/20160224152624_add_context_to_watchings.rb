class AddContextToWatchings < ActiveRecord::Migration
  def up
    add_column :watchings, :context, :integer

    context = Shared::Context::Manager.current_context

    ActiveRecord::Base.connection.execute("update watchings set context = #{context}")
  end

  def down
    remove_column :watchings, :context
  end
end
