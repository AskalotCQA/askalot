class ChangeContextFormatInWatchings < ActiveRecord::Migration
  def up
    remove_column :watchings, :context
    add_column :watchings, :context, :integer
  end

  def down
    remove_column :watchings, :context
    add_column :watchings, :context, :string
  end
end
