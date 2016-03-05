class ChangeContextFormatInWatchings < ActiveRecord::Migration
  def up
    remove_column :watchings, :context
    add_column :watchings, :context, :integer

    context = Shared::Context::Manager.current_context

    Shared::Watching.unscoped.find_each do |watching|
      watching.context = context

      watching.save!
    end
  end

  def down
    remove_column :watchings, :context
    add_column :watchings, :context, :string
  end
end
