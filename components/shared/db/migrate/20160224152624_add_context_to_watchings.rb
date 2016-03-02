class AddContextToWatchings < ActiveRecord::Migration
  def up
    add_column :watchings, :context, :string

    Shared::Watching.unscoped.find_each do |watching|
      watching.context = Shared::Context::Manager.current_context

      watching.save!
    end
  end

  def down
    remove_column :watchings, :context
  end
end
