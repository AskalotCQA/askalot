class AddContextToActivities < ActiveRecord::Migration
  def up
    add_column :activities, :context, :integer

    context = Shared::Context::Manager.current_context

    ActiveRecord::Base.connection.execute("update activities set context = #{context}")
  end

  def down
    remove_column :activities, :context
  end
end